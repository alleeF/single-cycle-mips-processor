module UD #(
    parameter INSTR_WIDTH = 12,
    parameter DATA_WIDTH  = 8,
    parameter ADDR_WIDTH  = 8
)(
    input  [DATA_WIDTH-1:0]  dInR,
    input  [INSTR_WIDTH-1:0] instructiune,
    input  [1:0]             selB,
    input  [1:0]             selAddr,
    input  [4:0]             opUAL,
    input                    clk,
    input                    rst,
    input                    selAW,
    input                    selD,
    input                    wR,

    output                   coMI,
    output                   co,
    output                   ov,
    output                   z,
    output [ADDR_WIDTH-1:0]  addrInstr,
    output [DATA_WIDTH-1:0]  outUAL,
    output [DATA_WIDTH-1:0]  dOutR
);

    wire [ADDR_WIDTH-1:0] tmpEticheta;

    // instantierea Blocului de Executie
    BE #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) BE (
        .clk         (clk),
        .rst         (rst),
        .dInR        (dInR),
        .instructiune(instructiune),
        .selAW       (selAW),
        .selD        (selD),
        .wR          (wR),
        .selB        (selB),
        .opUAL       (opUAL),
        .co          (co),
        .ov          (ov),
        .z           (z),
        .outUAL      (outUAL),
        .dOutR       (dOutR),
        .eticheta    (tmpEticheta)
    );

    // instantiere Blocului de Calcul al Adresei
    BCA #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) BCA (
        .eticheta  (tmpEticheta),
        .addrJ     (instructiune[ADDR_WIDTH-1:0]),
        .clk       (clk),
        .rst       (rst),
        .selAddr   (selAddr),
        .co        (coMI),
        .addrInstr (addrInstr)
    );

endmodule
