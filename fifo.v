module fifo(
    input i_clk,
    input i_rstn,
    input i_wr,
    input i_rd,
    input [31:0] i_data,
    output [31:0] o_data,
    output o_full,
    output o_empty
);

reg [2:0] wr_addr;
reg [2:0] rd_addr;

reg [31:0] mem[0:7];

// fifo mem write
always @(posedge i_clk, negedge i_rstn)
begin
    if (!i_rstn) 
    begin
        mem[0] <=0;
        mem[1] <=0;
        mem[2] <=0;
        mem[3] <=0;
        mem[4] <=0;
        mem[5] <=0;
        mem[6] <=0;
        mem[7] <=0;
    end
    else if(i_wr && !o_full)
    begin
        mem[wr_addr] <= i_data;
    end
end

// fifo mem write_addr plus
always @(posedge i_clk, negedge i_rstn)
begin
    if(!i_rstn)
    begin
        wr_addr <=0;
    end
    else if(i_wr && (!o_full) )
    begin
        wr_addr <= wr_addr +1;
    end
end

//fifo mem read
assign o_data = mem[rd_addr];

// fifo mem read_addr plus
always @(posedge i_clk, negedge i_rstn)
begin
    if(!i_rstn)
    begin
        rd_addr <=0;
    end
    else if(i_rd && !(o_empty))
    begin
        rd_addr <= rd_addr +1;
    end
end

// empty sign
assign o_empty = (wr_addr == rd_addr);

// full sign
assign o_full = ((wr_addr+1) == (rd_addr)) ;

endmodule