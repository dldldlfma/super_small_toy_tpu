module apb_master(
    input i_clk,

    output reg [31:0]   o_paddr,
    output reg          o_psel,
    output reg          o_pwrite,
    output reg [31:0]   o_pwdata,

    output reg          o_penable,
    input      [31:0]   i_prdata
);

initial
begin
    o_paddr         = 0;
    o_psel          = 0;
    o_pwrite        = 0;    
    o_pwdata        = 0;    
    o_penable       = 0;
end


task write(input [31:0] addr, input [31:0] data);
begin
    @(posedge i_clk);
    o_paddr     = addr;
    o_pwdata    = data;
    o_pwrite    = 1;
    o_psel      = 1;
    @(posedge i_clk);
    o_penable   = 1;
    @(posedge i_clk);
    o_psel      = 0;
    o_penable   = 0;
    o_pwrite    = 0;
end
endtask

task read(input [31:0] addr, output [31:0] data);
begin
    @(posedge i_clk);
    o_paddr   = addr;
    o_pwrite     = 0;
    o_psel       = 1;
    @(posedge i_clk);
    o_penable    = 1;
    @(posedge i_clk);
    data  = i_prdata;
    o_penable    = 0;
    o_psel       = 0;
end
endtask

endmodule