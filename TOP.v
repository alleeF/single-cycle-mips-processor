module TOP #(
    parameter INSTR_WIDTH = 16,
    parameter DATA_WIDTH  = 8,
    parameter ADDR_WIDTH  = 8
)(
    input rst,
    input clk,
    output co, ov, coMI, z,
    output [INSTR_WIDTH-1:0] instructiune,
    output [ADDR_WIDTH-1:0]  addrInstr,
    output [DATA_WIDTH-1:0]  outUAL,
    output [DATA_WIDTH-1:0]  dOutR,
    output [DATA_WIDTH-1:0]  dInR
);

    wire                  tmpWMD;
    wire [DATA_WIDTH-1:0] tmpOutUAL;
    wire [DATA_WIDTH-1:0] tmpDOutR;
    wire [DATA_WIDTH-1:0] tmpDInR;
    wire [ADDR_WIDTH-1:0] tmpAddInstr;
    wire [INSTR_WIDTH-1:0] tmpInstr;

    MI #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) MI (
        .dOut (tmpInstr),
        .addr (tmpAddInstr)
    );

    uP #(
        .INSTR_WIDTH(INSTR_WIDTH),
        .DATA_WIDTH (DATA_WIDTH),
        .ADDR_WIDTH (ADDR_WIDTH)
    ) uP (
        .instructiune (tmpInstr),
        .addrInstr    (tmpAddInstr),
        .co           (co),
        .ov           (ov),
        .coMI         (coMI),
        .z            (z),
        .wMD          (tmpWMD),
        .outUAL       (tmpOutUAL),
        .dOutR        (tmpDOutR),
        .dInR         (tmpDInR),
        .rst          (rst),
        .clk          (clk)
    );

    MD #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) MD (
        .we   (tmpWMD),
        .addr (tmpOutUAL[ADDR_WIDTH-1:0]),
        .dIn  (tmpDOutR),
        .dOut (tmpDInR),
        .clk  (clk)
    );

    assign instructiune = tmpInstr;
    assign addrInstr    = tmpAddInstr;
    assign outUAL       = tmpOutUAL;
    assign dInR         = tmpDInR;
    assign dOutR        = tmpDOutR;

endmodule
