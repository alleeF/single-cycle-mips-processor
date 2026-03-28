// MI = memorie ROM cu citire asincrona
// Program: suma numerelor pare din vectorul [7, 10, 5, 20]
// Rezultat asteptat: 30 (la adresa 10 din MD)

module MI #(
    parameter ADDR_WIDTH  = 8,
    parameter INSTR_WIDTH = 16
)(
    input  [ADDR_WIDTH-1:0]  addr,
    output [INSTR_WIDTH-1:0] dOut
);

localparam NOP     = 4'd0;
localparam opcodeR = 4'd0;
localparam ANDI    = 4'd1;
localparam ADDI    = 4'd3;
localparam LW      = 4'd7;
localparam SW      = 4'd8;
localparam BEQ     = 4'd9;
localparam J       = 4'd10;

localparam R0 = 3'd0;
localparam R1 = 3'd1;
localparam R2 = 3'd2;
localparam R3 = 3'd3;
localparam R4 = 3'd4;
localparam R5 = 3'd5;
localparam R6 = 3'd6;

localparam F_ADD = 3'b100;

// program
localparam I_0  = {ANDI,    R0, R0, 6'd0};

localparam I_1  = {ADDI,    R0, R1, 6'd7};
localparam I_2  = {SW,      R0, R1, 6'd0};

localparam I_3  = {ADDI,    R0, R1, 6'd10};
localparam I_4  = {SW,      R0, R1, 6'd1};

localparam I_5  = {ADDI,    R0, R1, 6'd5};
localparam I_6  = {SW,      R0, R1, 6'd2};

localparam I_7  = {ADDI,    R0, R1, 6'd20};
localparam I_8  = {SW,      R0, R1, 6'd3};

localparam I_9  = {ADDI,    R0, R2, 6'd4};
localparam I_10 = {ADDI,    R0, R3, 6'd0};
localparam I_11 = {ADDI,    R0, R4, 6'd0};

localparam I_12 = {LW,      R3, R5, 6'd0};
localparam I_13 = {ANDI,    R5, R6, 6'd1};
localparam I_14 = {BEQ,     R6, R0, 6'd1};
localparam I_15 = {J,       12'd17};

localparam I_16 = {opcodeR, R4, R5, R4, F_ADD};

localparam I_17 = {ADDI,    R3, R3, 6'd1};
localparam I_18 = {ADDI,    R2, R2, 6'b111111};
localparam I_19 = {BEQ,     R2, R0, 6'd1};
localparam I_20 = {J,       12'd12};

localparam I_21 = {SW,      R0, R4, 6'd10};
localparam I_22 = {J,       12'd22};

reg [INSTR_WIDTH-1:0] mem_content;

always @(*) begin
    case (addr)
        ADDR_WIDTH'd0:  mem_content = I_0;
        ADDR_WIDTH'd1:  mem_content = I_1;
        ADDR_WIDTH'd2:  mem_content = I_2;
        ADDR_WIDTH'd3:  mem_content = I_3;
        ADDR_WIDTH'd4:  mem_content = I_4;
        ADDR_WIDTH'd5:  mem_content = I_5;
        ADDR_WIDTH'd6:  mem_content = I_6;
        ADDR_WIDTH'd7:  mem_content = I_7;
        ADDR_WIDTH'd8:  mem_content = I_8;
        ADDR_WIDTH'd9:  mem_content = I_9;
        ADDR_WIDTH'd10: mem_content = I_10;
        ADDR_WIDTH'd11: mem_content = I_11;
        ADDR_WIDTH'd12: mem_content = I_12;
        ADDR_WIDTH'd13: mem_content = I_13;
        ADDR_WIDTH'd14: mem_content = I_14;
        ADDR_WIDTH'd15: mem_content = I_15;
        ADDR_WIDTH'd16: mem_content = I_16;
        ADDR_WIDTH'd17: mem_content = I_17;
        ADDR_WIDTH'd18: mem_content = I_18;
        ADDR_WIDTH'd19: mem_content = I_19;
        ADDR_WIDTH'd20: mem_content = I_20;
        ADDR_WIDTH'd21: mem_content = I_21;
        ADDR_WIDTH'd22: mem_content = I_22;
        default:        mem_content = {INSTR_WIDTH{1'b0}};
    endcase
end

assign dOut = mem_content;

endmodule
