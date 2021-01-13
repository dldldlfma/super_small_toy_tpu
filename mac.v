module mac(
    input i_clk,
    input i_rstn,
    input [31:0] i_data,
    input [31:0] i_weight,
    input [31:0] i_pre_result,
    output reg [31:0] o_data_next,
    output reg [31:0] o_result
);

wire [31:0] AB;
assign AB = i_data * i_weight;

always @(posedge i_clk, negedge i_rstn)
begin
    if(!i_rstn)
    begin
        o_result <= 0;
    end
    else
    begin
        o_result <= AB + i_pre_result;
    end
end

always @(posedge i_clk, negedge i_rstn)
begin
    if(!i_rstn)
    begin
        o_data_next <=0;
    end
    else
    begin
        o_data_next <= i_data;
    end
end


endmodule