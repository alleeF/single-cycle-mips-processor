module uP #(
    parameter INSTR_WIDTH = 16,
    parameter DATA_WIDTH  = 8,
    parameter ADDR_WIDTH  = 8
)(
    input  [INSTR_WIDTH-1:0] instructiune,
    output [ADDR_WIDTH-1:0]  addrInstr,
    input                    rst,
    input                    clk,
    output                   wMD,
    output [DATA_WIDTH-1:0]  outUAL,
    output [DATA_WIDTH-1:0]  dOutR,
    input  [DATA_WIDTH-1:0]  dInR,
    output                   co,
    output                   ov,
    output                   z,
    output                   coMI
);

    wire       tmpSelAW;
    wire       tmpSelD;
    wire       tmpWR;
    wire [1:0] tmpSelB;
    wire [4:0] tmpOpUAL;
    wire [1:0] tmpSelAddr;
    wire       tmpZ;

    assign z = tmpZ;

    UC UC (
        .opcode      (instructiune[INSTR_WIDTH-1:INSTR_WIDTH-4]),
        .operatieUAL (instructiune[2:0]),
        .wMD         (wMD),
        .selAW       (tmpSelAW),
        .selD        (tmpSelD),
        .wR          (tmpWR),
        .selB        (tmpSelB),
        .opUAL       (tmpOpUAL),
        .selAddr     (tmpSelAddr),
        .z           (tmpZ)
    );

    UD #(
        .INSTR_WIDTH(INSTR_WIDTH-4),
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) UD (
        .instructiune (instructiune[INSTR_WIDTH-5:0]),
        .dInR         (dInR),
        .rst          (rst),
        .clk          (clk),
        .selAW        (tmpSelAW),
        .selD         (tmpSelD),
        .wR           (tmpWR),
        .selB         (tmpSelB),
        .opUAL        (tmpOpUAL),
        .selAddr      (tmpSelAddr),
        .z            (tmpZ),
        .addrInstr    (addrInstr),
        .outUAL       (outUAL),
        .dOutR        (dOutR),
        .co           (co),
        .ov           (ov),
        .coMI         (coMI)
    );

endmodule
