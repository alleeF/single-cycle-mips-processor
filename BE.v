module BE #(parameter DATA_WIDTH = 8) (
	
	input                   selAW,
	input                   selD,
	input                   wR,
	input  [1:0]            selB,
	input  [4:0]            opUAL,
	input  [11:0]           instructiune,
	input  [DATA_WIDTH-1:0] dInR,
	input                   clk,
	input                   rst,
	
	output                  co,
	output                  ov,
	output                  z,
	output [DATA_WIDTH-1:0] outUAL,
	output [DATA_WIDTH-1:0] dOutR,
	output [DATA_WIDTH-1:0] eticheta
	
    );

	// semnale interne
	wire [2:0]              tmpAW;
	wire [DATA_WIDTH-1:0]   tmpUAL;
	wire [DATA_WIDTH-1:0]   tmpD;
	wire [DATA_WIDTH-1:0]   tmpQA;
	wire [DATA_WIDTH-1:0]   tmpQB;
	wire [DATA_WIDTH-1:0]   tmpU;
	wire [DATA_WIDTH-1:0]   tmpS;
	wire [DATA_WIDTH-1:0]   tmpB;
	 
	
	// selecteaza registrul destinatie
	muxAW muxAW (	
	
	.dIn0 ( instructiune[8:6] ),
	.dIn1 ( instructiune[5:3] ),
	.sel  ( selAW ),
	.dOut ( tmpAW ) 
	
	);
	
	// selecteaza sursa datelor pentru scriere in registri
	muxD #(
        .DATA_WIDTH(DATA_WIDTH)
    ) muxD (
	
	.dIn0 ( dInR ),
	.dIn1 ( tmpUAL ),
	.sel  ( selD ),
	.dOut ( tmpD )
	 
	); 
	
	// blocul de registri
	FR #(
        .DATA_WIDTH(DATA_WIDTH)
    ) FR (
	
	.we  ( wR ),
	.d   ( tmpD ),
	.aRW ( tmpAW ),
	.aRA ( instructiune[11:9] ),
	.aRB ( instructiune[8:6] ),
	.rst ( rst ),
	.clk ( clk ),
	.qA  ( tmpQA ),
	.qB  ( tmpQB )
	
	);
	
	// extensie zero / semn pentru imediat
	ext #(
        .DATA_WIDTH(DATA_WIDTH)
    ) ext (
	
	.dIn   ( instructiune [5:0] ),
	.dOutU ( tmpU ),
	.dOutS ( tmpS )
	
	);
	
	// selecteaza al doilea operand al ALU
	muxB #(
        .DATA_WIDTH(DATA_WIDTH)
    ) muxB (
	
	.sel  ( selB ),
	.dIn0 ( {DATA_WIDTH{1'b0}} ),
	.dIn1 ( tmpQB ),
	.dIn2 ( tmpU ),
	.dIn3 ( tmpS ),
	.dOut ( tmpB )
	
	);
	
	// unitatea aritmetico-logica
	UAL #(
        .DATA_WIDTH(DATA_WIDTH)
    ) UAL (
	
	.A     ( tmpQA ),
	.B     ( tmpB ),
	.opUAL ( opUAL ),
	.F     ( tmpUAL ),
	.CO    ( co ),
	.OV    ( ov ),
	.Z     ( z )
	
	);

	assign dOutR    = tmpQB;
	assign eticheta = tmpU;
	assign outUAL   = tmpUAL;

endmodule
	
module muxAW ( 
	
   input         sel,	
   input  [2:0]  dIn0,
   input  [2:0]  dIn1,
   output [2:0]  dOut
   
   );	
   
   reg [2:0] dOut_s;
   
   always @(*) begin   
	   
	   case (sel)
		   
		   1'b0:    dOut_s = dIn0;
		   1'b1:    dOut_s = dIn1;
		   default: dOut_s = 3'bxxx;
	   
	  endcase
   end
   
   assign dOut = dOut_s;
endmodule



module muxD #(parameter DATA_WIDTH = 8) ( 
	
   input                    sel,	
   input  [DATA_WIDTH-1:0]  dIn0,
   input  [DATA_WIDTH-1:0]  dIn1,
   output [DATA_WIDTH-1:0]  dOut
   
   );	
   
   reg [DATA_WIDTH-1:0] dOut_s;
   
   always @(*) begin   
	   
	   case (sel)
		   
		   1'b0:    dOut_s = dIn0;
		   1'b1:    dOut_s = dIn1;
		   default: dOut_s = {DATA_WIDTH{1'bx}};
	   
	  endcase
   end
   
   assign dOut = dOut_s;
endmodule



module ext #(parameter DATA_WIDTH = 8) (
	
	input  [5:0] dIn,
	output [DATA_WIDTH-1:0] dOutU,
	output [DATA_WIDTH-1:0] dOutS
	
	);
	
	// extensie cu 0 si extensie cu semn
	assign dOutU = {{(DATA_WIDTH-6){1'b0}}, dIn};
	assign dOutS = {{(DATA_WIDTH-6){dIn[5]}}, dIn};
	
endmodule	
	



module muxB #(parameter DATA_WIDTH = 8) ( 
	
   input  [1:0]             sel,	
   input  [DATA_WIDTH-1:0]  dIn0,
   input  [DATA_WIDTH-1:0]  dIn1,
   input  [DATA_WIDTH-1:0]  dIn2,
   input  [DATA_WIDTH-1:0]  dIn3,
   output [DATA_WIDTH-1:0]  dOut
   
   );	
   
   reg [DATA_WIDTH-1:0] dOut_s;
   
   always @(*) begin   
	   
	   case (sel)
		   
		   2'b00:    dOut_s = dIn0;
		   2'b01:    dOut_s = dIn1;
		   2'b10:    dOut_s = dIn2;	
		   2'b11:    dOut_s = dIn3;
		   default:  dOut_s = {DATA_WIDTH{1'bx}};
	   
	  endcase
   end
   
   assign dOut = dOut_s;
endmodule
