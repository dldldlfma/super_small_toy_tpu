module apb_slave (
    input i_clk,

    input [31:0] i_paddr,
    input        i_psel,
    input        i_pwrite,
    input [31:0] i_pwdata,
    input        i_penable,
    output reg [31:0] o_prdata
);

parameter DEPTH = 256;

reg [31:0] mem [0:DEPTH-1];

initial
begin
    o_prdata =0;
end

wire write_enb; 
assign write_enb = i_psel & i_penable & i_pwrite;
wire read_enb;
assign read_enb = i_psel & i_penable & !i_pwrite;

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
        o_prdata = mem[i_paddr];
    end
    else
    begin
        o_prdata = 0;
    end
end

endmodule