module UAL #(parameter DATA_WIDTH = 8) (  
	
	input  [DATA_WIDTH-1:0] A,
	input  [DATA_WIDTH-1:0] B,
	input  [4:0]            opUAL,
	output [DATA_WIDTH-1:0] F,
	output                  CO,
	output                  OV,
	output                  Z
	
	);
	
	wire [DATA_WIDTH-1:0] tmpSet;
	wire [DATA_WIDTH-1:0] tmpSgn;
	wire [DATA_WIDTH:0]   tmpC;
	wire [DATA_WIDTH-1:0] tmpF;
	wire                  tmpOV;
	
	assign tmpSet[DATA_WIDTH-1:1] = {(DATA_WIDTH-1){1'b0}};
	assign tmpOV = tmpC[DATA_WIDTH-1] ^ tmpC[DATA_WIDTH];
	assign CO = tmpC[DATA_WIDTH];
	assign OV = tmpOV;	
	assign tmpF = F;
	assign Z  = ~|tmpF; 
	assign tmpC[0] = opUAL[2];
	
	// genereaza bitul LSB pentru operatiile SLT / SLTU
	setLSB setGenerator (
	
	.sign    (opUAL[4]),
	.ov      (OV),
	.setS    (tmpSgn[DATA_WIDTH-1]),
	.setU    (CO),
	.lsbValue(tmpSet[0]) 
	
	);
	
	generate
	genvar i;
	
	  for(i = 0; i < DATA_WIDTH; i = i + 1)
	    begin: instante
			
			ual1b Ui (
			
			.a     (A[i]),
			.b     (B[i]),
			.set   (tmpSet[i]),
			.inva  (opUAL[3]),
			.invb  (opUAL[2]),
			.ci    (tmpC[i]),
			.selOp (opUAL[1:0]),
			.f     (F[i]), 
			.co    (tmpC[i+1]),
			.sgn   (tmpSgn[i])
			);  
	
	    end	
		
	endgenerate
	
endmodule


module setLSB (
		 
		 input  sign,
		 input  ov,
		 input  setS,
		 input  setU, 
		 output lsbValue
		 
		 );		
		 
		 wire tmpS, tmpU;
		 
		 assign tmpS = ov ^ setS;
		 assign tmpU = ~setU; 
		 
		 mux2 MUX2 (
			.sel (sign),
		    .dIn1(tmpS),
		    .dIn0(tmpU),
		    .dOut(lsbValue)            
	     ); 	 
	
endmodule


module ual1b
	(
	    input  a,
	    input  b,
	    input  inva,
	    input  invb, 
	    input  set,
	    input  ci,
	    input  [1:0] selOp,
	    output co,
	    output sgn,
	    output f
	); 	
	
	// semnale interne
	wire tmpA, tmpB, tmpAndNor, tmpOr, tmpAddSub;  
	
	// sumator pe 1 bit
	add1b U0(
	    .ci(ci),
	    .b (tmpB),
	    .a (tmpA),
	    .s (tmpAddSub),
	    .co(co)          
	); 	   
	
	// selectie operatie finala
	mux4_1b U1(
	    .sel (selOp),
	    .dIn3(set),
	    .dIn2(tmpAddSub),
	    .dIn1(tmpOr),
	    .dIn0(tmpAndNor),
	    .dOut(f)            
	); 
	
	assign tmpA      = a ^ inva;  
	assign tmpB      = b ^ invb;
	assign tmpAndNor = tmpA & tmpB;
	assign tmpOr     = tmpA | tmpB; 
	assign sgn       = tmpAddSub;
	
endmodule

module add1b
	(
	    input  a,
	    input  b,
	    input  ci,
	    output s,
	    output co
	);	 
	
  	assign {co, s} = a + b + ci; 
  
endmodule

module mux4_1b (
  input  [1:0] sel,
  input        dIn0,
  input        dIn1,
  input        dIn2,
  input        dIn3,
  output reg   dOut
);

always @(*) begin
  case (sel)
    2'b00: dOut = dIn0;
    2'b01: dOut = dIn1;
    2'b10: dOut = dIn2;
    2'b11: dOut = dIn3;
    default: dOut = 1'b0;
  endcase
end

endmodule


