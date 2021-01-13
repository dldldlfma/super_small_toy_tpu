module tpu_top(

    input i_clk,
    input i_rstn,
    input [31:0] in1,
    input [31:0] in2,
    input in1_en,
    input in2_en,
    input start,
    output [2:0] o_full,
    output [2:0] o_empty,
    output [31:0] out1,
    output [31:0] out2,
    output done,


    // apb slave
    input [31:0] i_paddr,
    input        i_psel,
    input        i_pwrite,
    input [31:0] i_pwdata,
    input        i_penable,
    output reg [31:0] o_prdata,
    output reg [3:0] counter

);


parameter MMU_BASE_ADDR = 0;
parameter ADDRESS_W00 = (MMU_BASE_ADDR + 32'h04);
parameter ADDRESS_W01 = (MMU_BASE_ADDR + 32'h08);
parameter ADDRESS_W10 = (MMU_BASE_ADDR + 32'h0c);
parameter ADDRESS_W11 = (MMU_BASE_ADDR + 32'h10);
parameter DEPTH = 256;

reg [31:0] mem [0:DEPTH-1];

wire [31:0] mac00_in;
wire [31:0] mac01_in;
wire [31:0] mac10_in;
wire [31:0] mac11_in;

wire [31:0] mac00_out;
wire [31:0] mac01_out;
wire [31:0] mac10_out;
wire [31:0] mac11_out;

wire [31:0] systolic_in1;
wire [31:0] systolic_in2;

assign out1 = mac10_out;
assign out2 = mac11_out;

wire fifo_en;
assign fifo_en = (start) & (counter < 2);

fifo u_fifo00(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_wr(in1_en),
    .i_rd(fifo_en),
    .i_data(in1),
    .o_data(systolic_in1),
    .o_full(o_full[0]),
    .o_empty(o_empty[0])
);

fifo u_fifo01(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_wr(in2_en),
    .i_rd(fifo_en),
    .i_data(in2),
    .o_data(systolic_in2),
    .o_full(o_full[1]),
    .o_empty(o_empty[1])
);

systolic_reg u_systolic(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .in1(systolic_in1),
    .in2(systolic_in2),
    .out1(mac00_in),
    .out2(mac10_in)
);

mac u_mac00(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_data(mac00_in),
    .i_weight(mem[ADDRESS_W00]),
    .i_pre_result(32'h0),
    .o_data_next(mac01_in),
    .o_result(mac00_out)
);

mac u_mac01(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_data(mac01_in),
    .i_weight(mem[ADDRESS_W01]),
    .i_pre_result(32'h0),
    .o_data_next(),
    .o_result(mac01_out)
);

mac u_mac10(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_data(mac10_in),
    .i_weight(mem[ADDRESS_W10]),
    .i_pre_result(mac00_out),
    .o_data_next(mac11_in),
    .o_result(mac10_out)
);

mac u_mac11(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_data(mac11_in),
    .i_weight(mem[ADDRESS_W11]),
    .i_pre_result(mac01_out),
    .o_data_next(),
    .o_result(mac11_out)
);


wire result_fifo_wr;
wire result_fifo_rd;
wire [31:0] result_fifo_i_data;
wire [31:0] result_fifo_o_data;

fifo u_fifo_result(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_wr(result_fifo_wr),
    .i_rd(result_fifo_rd),
    .i_data(result_fifo_i_data),
    .o_data(result_fifo_o_data),
    .o_full(o_full[2]),
    .o_empty(o_empty[2])
);

wire write_enb; 
assign write_enb = i_psel & i_penable & i_pwrite;
wire read_enb;
assign read_enb = i_psel & i_penable & !i_pwrite;
assign result_fifo_rd = read_enb;

always @(posedge i_clk)
begin
    if(write_enb)
    begin
        mem[i_paddr] <= i_pwdata;
    end
end

always @(*)
begin
    if(read_enb)
    begin
        //o_prdata = mem[i_paddr];
        o_prdata = result_fifo_o_data;
    end
    else
    begin
        o_prdata = 0;
    end
end

always @(posedge i_clk, negedge i_rstn)
begin
    if(!i_rstn)
    begin
        counter<=0;
    end
    else if(start)
    begin
        counter <= counter +1;
    end
    else
    begin
        counter <=0;
    end
end

assign result_fifo_wr = ((counter == 4'h2) || 
                         (counter == 4'h3) || 
                         (counter == 4'h4) || 
                         (counter == 4'h5)) ? 1 : 0;

assign result_fifo_i_data = ((counter == 4'h2) || (counter == 4'h4)) ? out1 : 
                            ((counter == 4'h3) || (counter == 4'h5)) ? out2 : 0;

assign done = (counter >= 4'h5) ? 1 : 0;

endmodule