
// FR = Register File
// - numar de registri = 2^REG_ADDR_WIDTH
// - fiecare registru are DATA_WIDTH biti
// - 2 porturi de citire (qA, qB)
// - 1 port de scriere (d)


module FR #(
    parameter DATA_WIDTH     = 8,  // dimensiunea datelor din registri
    parameter REG_ADDR_WIDTH = 3   // nr. biti pentru adresa registrului
)(
    input                       we,    // write enable
    input  [DATA_WIDTH-1:0]     d,     // date de scriere
    input  [REG_ADDR_WIDTH-1:0] aRW,   // adresa registru scriere
    input  [REG_ADDR_WIDTH-1:0] aRA,   // adresa citire port A
    input  [REG_ADDR_WIDTH-1:0] aRB,   // adresa citire port B
    input                       rst,
    input                       clk,
    output [DATA_WIDTH-1:0]     qA,    // iesire port A
    output [DATA_WIDTH-1:0]     qB     // iesire port B
);

    // numar total de registri
    localparam REG_COUNT = 2**REG_ADDR_WIDTH;

    // semnale interne
    wire [REG_COUNT-1:0] tmpLd;                // semnale de load pentru fiecare registru
    wire [DATA_WIDTH-1:0] tmpQ [0:REG_COUNT-1]; // iesiri din fiecare registru

    
    // DEMUX - activeaza un singur registru pentru scriere
  
    dmuxN #(
        .N(REG_COUNT)
    ) dmuxN_inst (
        .sel  (aRW),   // selecteaza registrul de scriere
        .dIn  (we),    // write enable global
        .dOut (tmpLd)  // semnal load individual pe fiecare registru
    );

  
   
    // fiecare registru este instantiat automat (generate)
   
    genvar i;
    generate
        for (i = 0; i < REG_COUNT; i = i + 1) begin : instante
            rppN #(
                .DATA_WIDTH(DATA_WIDTH)
            ) rppi (
                .ld  (tmpLd[i]), // enable scriere pentru registrul i
                .clk (clk),
                .rst (rst),
                .d   (d),        // date de intrare comune
                .q   (tmpQ[i])   // iesirea registrului i
            );
        end
    endgenerate

    // =======================================================
    // CITIRE REGISTRI (2 porturi)
    // =======================================================
    assign qA = tmpQ[aRA]; // citire registru A
    assign qB = tmpQ[aRB]; // citire registru B

endmodule


// =======================================================
// DEMUX generic
// - transforma un semnal dIn intr-un vector one-hot
// - doar un bit din dOut va fi 1 (cel selectat)
// =======================================================

module dmuxN #(
    parameter N = 8,           // numar iesiri
    parameter SEL_WIDTH = 3    // latimea selectului
)(
    input  dIn,                        // semnal intrare
    input  [SEL_WIDTH-1:0] sel,        // select
    output [N-1:0] dOut                // iesiri one-hot
);

    // daca dIn = 1 -> se seteaza bitul selectat
    // daca dIn = 0 -> toate iesirile sunt 0
    assign dOut = dIn ? ({ {N-1{1'b0}}, 1'b1 } << sel) : {N{1'b0}};

endmodule


// =======================================================
// rppN = registru parametrizabil
// - scriere conditionata de ld
// - reset sincron
// =======================================================

module rppN #(
    parameter DATA_WIDTH = 8
)(
    input                   ld,   // load enable
    input                   clk,
    input                   rst,
    input  [DATA_WIDTH-1:0] d,    // date intrare
    output [DATA_WIDTH-1:0] q     // iesire
);

    reg [DATA_WIDTH-1:0] q_s;

    always @(posedge clk) begin
        if (rst)
            q_s <= {DATA_WIDTH{1'b0}}; // reset la 0
        else if (ld)
            q_s <= d;                 // scriere
    end

    assign q = q_s;

endmodule
