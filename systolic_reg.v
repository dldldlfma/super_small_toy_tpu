module systolic_reg(
    input i_clk,
    input i_rstn,
    input [31:0] in1,
    input [31:0] in2,
    output [31:0] out1,
    output [31:0] out2
);

reg [31:0] delay10;
reg [31:0] delay20;
reg [31:0] delay21;

assign out1 = delay10;
assign out2 = delay21;

always @(posedge i_clk, negedge i_rstn)
begin
    if(!i_rstn)
    begin
        delay10<=0;
        delay20<=0;
        delay21<=0;
    end
    else
    begin
        delay10<=in1;
        delay20<=in2;
        delay21<=delay20;
    end
end

endmodule