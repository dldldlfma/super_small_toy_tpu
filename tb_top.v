module tb_top();

parameter ADDRESS_W00 = 0;
parameter ADDRESS_W01 = 1;
parameter ADDRESS_W10 = 2;
parameter ADDRESS_W11 = 3;
parameter DEPTH = 4;

reg i_clk;
reg i_rstn;
reg [31:0] in1;
reg [31:0] in2;
reg in1_en;
reg in2_en;
reg start;
wire [2:0] o_full;
wire [2:0] o_empty;
// wire [31:0] out1;
// wire [31:0] out2;
wire done;

wire [31:0]  paddr;
wire         psel;
wire         pwrite;
wire [31:0]  pwdata;
wire         penable;
wire [31:0] prdata;
reg [31:0] final_result;

always 
begin
    #5;
    i_clk = !i_clk;
end

initial
begin
    start <=  0;
    i_clk <=  0;
    i_rstn <= 1;
    in1_en <= 0;
    in2_en <= 0;
    #2;
    i_rstn <= 0;
    #2;
    i_rstn <= 1;
    @(posedge i_clk);
    u1_apb_master.write(ADDRESS_W00, 32'h0001);
    u1_apb_master.write(ADDRESS_W01, 32'h0002);
    u1_apb_master.write(ADDRESS_W10, 32'h0003);
    u1_apb_master.write(ADDRESS_W11, 32'h0004);
    @(posedge i_clk);
    in1 <= 1;
    in2 <= 2;
    in1_en <=1;
    in2_en <=1;
    @(posedge i_clk);
    in1 <= 3;
    in2 <= 4;
    in1_en <=1;
    in2_en <=1;
    @(posedge i_clk);
    in1 <= 5;
    in2 <= 6;
    in1_en <=1;
    in2_en <=1;
    @(posedge i_clk);
    in1 <= 7;
    in2 <= 8;
    in1_en <=1;
    in2_en <=1;
    @(posedge i_clk);
    in1_en <=0;
    in2_en <=0;
    start <=1;

    while(!done)
    begin
        @(posedge i_clk);
    end

    start <= 0;
    u1_apb_master.read(0,final_result);
    u1_apb_master.read(0,final_result);
    u1_apb_master.read(0,final_result);
    u1_apb_master.read(0,final_result);

    @(posedge i_clk);
    u1_apb_master.write(ADDRESS_W00, 32'h0001);
    u1_apb_master.write(ADDRESS_W01, 32'h0002);
    u1_apb_master.write(ADDRESS_W10, 32'h0002);
    u1_apb_master.write(ADDRESS_W11, 32'h0003);
    @(posedge i_clk);
    in1 <= 9;
    in2 <= 10;
    in1_en <=1;
    in2_en <=1;
    @(posedge i_clk);
    in1 <= 11;
    in2 <= 12;
    in1_en <=1;
    in2_en <=1;
    @(posedge i_clk);
    in1_en <=0;
    in2_en <=0;
    start <=1;
    while(!done)
    begin
        @(posedge i_clk);
    end
    start <=0;
    u1_apb_master.read(0,final_result);
    u1_apb_master.read(0,final_result);
    u1_apb_master.read(0,final_result);
    u1_apb_master.read(0,final_result);
    @(posedge i_clk);
    start <=1;
    while(!done)
    begin
        @(posedge i_clk);
    end
    start <=0;
    u1_apb_master.read(0,final_result);
    u1_apb_master.read(0,final_result);
    u1_apb_master.read(0,final_result);
    u1_apb_master.read(0,final_result);
    @(posedge i_clk);
    $finish;
end

tpu_top u0(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .in1(in1),
    .in2(in2),
    .in1_en(in1_en),
    .in2_en(in2_en),
    .start(start),
    .o_full(o_full),
    .o_empty(o_empty),
    // .out1(out1),
    // .out2(out2),
    .done(done),
    .i_paddr(paddr),
    .i_psel(psel),
    .i_pwrite(pwrite),
    .i_pwdata(pwdata),
    .i_penable(penable),
    .o_prdata(prdata)
);

apb_master u1_apb_master(
    .i_clk(i_clk),
    .o_paddr(paddr),
    .o_psel(psel),
    .o_pwrite(pwrite),
    .o_pwdata(pwdata),
    .o_penable(penable),
    .i_prdata(prdata)
);


initial
begin
    $dumpfile("tpu_top_result.vcd");
    $dumpvars(-1,u0);
end

endmodule