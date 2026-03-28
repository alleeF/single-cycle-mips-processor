module mux2(
    input  sel,
    input  dIn1,
    input  dIn0,
    output reg dOut
);

    always @(*) begin
        case (sel)
            1'b0: dOut = dIn0;
            1'b1: dOut = dIn1;
            default: dOut = 1'bx;
        endcase
    end

endmodule


module mux4 #(
    parameter ADDR_WIDTH = 8
)(
    input  [1:0] sel,
    input  [ADDR_WIDTH-1:0] dIn0,
    input  [ADDR_WIDTH-1:0] dIn1,
    input  [ADDR_WIDTH-1:0] dIn2,
    input  [ADDR_WIDTH-1:0] dIn3,
    output reg [ADDR_WIDTH-1:0] dOut
);

    always @(*) begin
        case (sel)
            2'b00: dOut = dIn0;
            2'b01: dOut = dIn1;
            2'b10: dOut = dIn2;
            2'b11: dOut = dIn3;
            default: dOut = {ADDR_WIDTH{1'b0}};
        endcase
    end

endmodule


module addN #(
    parameter ADDR_WIDTH = 8
)(
    input  [ADDR_WIDTH-1:0] a,
    input  [ADDR_WIDTH-1:0] b,
    input                   ci,
    output [ADDR_WIDTH-1:0] s,
    output                  co
);

    assign {co, s} = a + b + ci;

endmodule


module rpp_no_ld #(
    parameter ADDR_WIDTH = 8
)(
    input                   clk,
    input                   rst,
    input  [ADDR_WIDTH-1:0] d,
    output [ADDR_WIDTH-1:0] q
);

    reg [ADDR_WIDTH-1:0] q_s;

    always @(posedge clk) begin
        if (rst)
            q_s <= {ADDR_WIDTH{1'b0}};
        else
            q_s <= d;
    end

    assign q = q_s;

endmodule


module dff(
    input  clk,
    input  rst,
    input  d,
    output q
);

    reg tmp;

    always @(posedge clk) begin
        if (rst)
            tmp <= 1'b0;
        else
            tmp <= d;
    end

    assign q = tmp;

endmodule


module BCA #(
    parameter ADDR_WIDTH = 8
)(
    input  [1:0] selAddr,
    input  [ADDR_WIDTH-1:0] eticheta,
    input  [ADDR_WIDTH-1:0] addrJ,
    input                   clk,
    input                   rst,

    output                  co,
    output [ADDR_WIDTH-1:0] addrInstr
);

    wire [ADDR_WIDTH-1:0] tmpAddr;
    wire [ADDR_WIDTH-1:0] tmpAddrPC;
    wire [ADDR_WIDTH-1:0] tmpAddrInc;
    wire [ADDR_WIDTH-1:0] tmpAddrBeq;
    wire tmpCoInc;
    wire tmpCoBeq;
    wire tmpCoBeqR;

    // mux pentru carry out
    mux2 muxCo (
        .dIn0 (tmpCoInc),
        .dIn1 (tmpCoBeqR),
        .sel  (selAddr[1]),
        .dOut (co)
    );

    // mux pentru urmatoarea adresa
    mux4 #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) muxAddr (
        .dIn0 ({ {(ADDR_WIDTH-1){1'b0}}, 1'b1 }),
        .dIn1 (tmpAddrInc),
        .dIn2 (tmpAddrBeq),
        .dIn3 (addrJ),
        .sel  (selAddr),
        .dOut (tmpAddr)
    );

    // incrementare PC
    addN #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) addIncr (
        .a  (tmpAddrPC),
        .b  ({ {(ADDR_WIDTH-1){1'b0}}, 1'b1 }),
        .ci (1'b0),
        .co (tmpCoInc),
        .s  (tmpAddrInc)
    );

    // calcul adresa branch
    addN #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) addBeq (
        .a  (tmpAddrInc),
        .b  (eticheta),
        .ci (1'b0),
        .co (tmpCoBeq),
        .s  (tmpAddrBeq)
    );

    // PC
    rpp_no_ld #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) PC (
        .d   (tmpAddr),
        .clk (clk),
        .rst (rst),
        .q   (tmpAddrPC)
    );

    // registru pentru carry branch
    dff dFF (
        .d   (tmpCoBeq),
        .clk (clk),
        .rst (rst),
        .q   (tmpCoBeqR)
    );

    assign addrInstr = tmpAddrPC;

endmodule
