`timescale 1ns/1ns

module tb();

reg         i_clk;
reg         i_rstn;
reg  [15:0] i_data;
reg  [15:0] i_weight;
reg  [31:0] i_pre_result;
wire [15:0] o_data_next;
wire [15:0] o_result;

mac u0(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_data(i_data),
    .i_weight(i_weight),
    .i_pre_result(i_pre_result),
    .o_data_next(o_data_next),
    .o_result(o_result)
);

always 
begin
    #5;
    i_clk <= ~i_clk;
end

task d_in;
    input [15:0] i_d;
    input [15:0] i_w;
    input [31:0] i_pr;
    begin
        i_data <= i_d;
        i_weight <= i_w;
        i_pre_result <= i_pr;        
        @(posedge i_clk);
    end
endtask

initial
begin
    i_clk=0;
    i_rstn=1;
    #1 i_rstn=0;
    #1 i_rstn=1;
    @(posedge i_clk);
    //d_in(.i_d(1), .i_w(2), .i_pre(3));
    d_in(1, 2, 3);
    d_in(1, 4, 3);
    d_in(4, 2, 6);
    @(posedge i_clk);
    $finish;
end

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(-1,u0);
end

endmodule