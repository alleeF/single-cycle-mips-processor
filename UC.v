	module UC (
	input [3:0] opcode,
	input [2:0] operatieUAL,
	input z,
	output selAW,
	output selD,
	output wR,
	output [1:0] selB,
	output [4:0] opUAL,
	output [1:0] selAddr,
	output wMD
	
	);
localparam	opcodeR      = 4'b0000;	 
localparam  opcodeANDI   = 4'b0001;
localparam  opcodeORI    = 4'b0010;
localparam  opcodeADDI   = 4'b0011;  
localparam  opcodeADDUI  = 4'b0100;	
localparam  opcodeSLTI   = 4'b0101;
localparam  opcodeSLTUI  = 4'b0110;
localparam  opcodeLW     = 4'b0111;	
localparam  opcodeSW     = 4'b1000;
localparam  opcodeBEQ    = 4'b1001;
localparam  opcodeJ      = 4'b1010;	

localparam  operatieUAL_NOP  = 3'b000;
localparam  operatieUAL_AND  = 3'b001;
localparam  operatieUAL_OR   = 3'b010;
localparam  operatieUAL_NOR  = 3'b011;
localparam  operatieUAL_ADD  = 3'b100;
localparam  operatieUAL_SUB  = 3'b101;
localparam  operatieUAL_SLT  = 3'b110;
localparam  operatieUAL_SLTU = 3'b111; 

//iesirile
//                         selAw selD    wR     selB     opUAL     selAddr   wMD

localparam ctrlNOP   = 13'b0______0______0______00______00000______01________0;
localparam ctrlAND   = 13'b1______1______1______01______00000______01________0;
localparam ctrlOR    = 13'b1_1_1_01_00001_01_0;
localparam ctrlNOR   = 13'b1_1_1_01_01100_01_0;
localparam ctrlADD   = 13'b1_1_1_01_00010_01_0;
localparam ctrlSUB   = 13'b1_1_1_01_00110_01_0;
localparam ctrlSLT   = 13'b1_1_1_01_10111_01_0;
localparam ctrlSLTU  = 13'b1_1_1_01_00111_01_0;

localparam ctrlANDI  = 13'b0_1_1_10_00000_01_0;
localparam ctrlORI   = 13'b0_1_1_10_00001_01_0;
localparam ctrlADDI  = 13'b0_1_1_11_00010_01_0;
localparam ctrlADDUI = 13'b0_1_1_10_00010_01_0;
localparam ctrlSLTI  = 13'b0_1_1_11_10111_01_0;
localparam ctrlSLTUI = 13'b0_1_1_10_00111_01_0;

localparam ctrlLW    = 13'b0_0_1_10_00010_01_0;
localparam ctrlSW    = 13'b0_0_0_10_00010_01_1;

localparam ctrlBEQ_1 = 13'b0_0_0_01_00110_10_0;
localparam ctrlBEQ_0 = 13'b0_0_0_01_00110_01_0;

localparam ctrlJ     = 13'b0_0_0_00_00000_11_0;	

reg [12:0] tmp;	  

always @ (opcode, operatieUAL, z)  begin 
	
	casex ({opcode,operatieUAL,z}) 
		// Tip R
            {opcodeR, operatieUAL_NOP,  1'bx}: tmp = ctrlNOP;
            {opcodeR, operatieUAL_AND,  1'bx}: tmp = ctrlAND;
            {opcodeR, operatieUAL_OR,   1'bx}: tmp = ctrlOR;
            {opcodeR, operatieUAL_NOR,  1'bx}: tmp = ctrlNOR;
            {opcodeR, operatieUAL_ADD,  1'bx}: tmp = ctrlADD;
            {opcodeR, operatieUAL_SUB,  1'bx}: tmp = ctrlSUB;
            {opcodeR, operatieUAL_SLT,  1'bx}: tmp = ctrlSLT;
            {opcodeR, operatieUAL_SLTU, 1'bx}: tmp = ctrlSLTU;
	   // Tip I
            {opcodeANDI,  3'bxxx, 1'bx}: tmp = ctrlANDI;
            {opcodeORI,   3'bxxx, 1'bx}: tmp = ctrlORI;
            {opcodeADDI,  3'bxxx, 1'bx}: tmp = ctrlADDI;
            {opcodeADDUI, 3'bxxx, 1'bx}: tmp = ctrlADDUI;
            {opcodeSLTI,  3'bxxx, 1'bx}: tmp = ctrlSLTI;
            {opcodeSLTUI, 3'bxxx, 1'bx}: tmp = ctrlSLTUI;

       // Transfer date
            {opcodeLW,    3'bxxx, 1'bx}: tmp = ctrlLW;
            {opcodeSW,    3'bxxx, 1'bx}: tmp = ctrlSW;

       // BEQ
            {opcodeBEQ,   3'bxxx, 1'b1}: tmp = ctrlBEQ_1;
            {opcodeBEQ,   3'bxxx, 1'b0}: tmp = ctrlBEQ_0;

       // Jump
            {opcodeJ,     3'bxxx, 1'bx}: tmp = ctrlJ;

            default: tmp = ctrlNOP;	
     endcase	
	
end

assign selAW   = tmp[12];
assign selD    = tmp[11];
assign wR      = tmp[10];
assign selB    = tmp[9:8];
assign opUAL   = tmp[7:3];
assign selAddr = tmp[2:1];
assign wMD     = tmp[0];

endmodule
