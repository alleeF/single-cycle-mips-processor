`timescale 1ns / 1ps
module TOP_tb();
parameter W = 8;
reg  clk;
reg  rst;

wire co;
wire ov;
wire coMI;
wire z;
wire [W-1:0] addrInstr;
wire [15:0]  instructiune;
wire [W-1:0] outUAL; 
wire [W-1:0] dOutR;
wire [W-1:0] dInR;

TOP DUT(
    .clk(clk),
    .rst(rst),    
    .co(co),
    .ov(ov),
    .coMI(coMI),    
    .z(z),         
    .addrInstr(addrInstr),
    .instructiune(instructiune),
    .dOutR(dOutR),
    .dInR(dInR),
    .outUAL(outUAL)
    );
 
// parametri de timp
localparam TCLK   = 20;
localparam PHASE  = 10;

initial #2000 $finish;
// generare stimuli
initial clk = 1'b0;
always #(TCLK/2) clk <= ~ clk;

initial begin rst = 1'b1; #TCLK rst = 1'b0; end

endmodule
