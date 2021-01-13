module tb_fifo();

reg i_clk;
reg i_rstn;
reg i_wr;
reg i_rd;
reg  [15:0] i_data;
wire [15:0] o_data;
wire o_full;
wire o_empty;

fifo u0_fifo(
    .i_clk(i_clk),
    .i_rstn(i_rstn),
    .i_wr(i_wr),
    .i_rd(i_rd),
    .i_data(i_data),
    .o_data(o_data),
    .o_full(o_full),
    .o_empty(o_empty)
);

always 
begin
    #5
    i_clk <= ~i_clk;
end

task fifo_write;
    input [31:0] data;
    begin
        i_wr <= 1;
        i_data <= data;
        @(posedge i_clk);
        #2;
        i_wr <= 0;
    end
endtask

task fifo_read;
    begin
        i_rd <= 1;
        @(posedge i_clk);
        #2;
        i_rd <= 0;
    end
endtask

initial
begin
    i_rd <=0;
    i_wr <=0;
    i_clk  <=0;
    i_rstn <=1;
    #1;
    i_rstn <=0;
    #1;
    i_rstn <=1;
    #1;
    fifo_write(3);
    fifo_read();
    fifo_write(4);
    fifo_read();
    
    fifo_write(1);
    fifo_write(2);
    fifo_write(3);
    fifo_write(4);
    
    fifo_write(5);
    fifo_write(6);
    fifo_write(7);
    fifo_write(8);

    fifo_write(9);
    fifo_write(10);

    fifo_read();
    fifo_read();
    fifo_read();
    fifo_read();

    fifo_read();
    fifo_read();
    fifo_read();
    fifo_read();

    fifo_read();
    fifo_read();
    fifo_read();
    fifo_read();
    fifo_write(1);
    fifo_read();

    @(posedge i_clk);
    $finish; 
end

initial
begin
    $dumpfile("fifo_wave.vcd");
    $dumpvars(-1,u0_fifo);
    
end

endmodule