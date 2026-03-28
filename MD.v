module MD #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
)(
    input                    clk,
    input                    we,
    input  [DATA_WIDTH-1:0]  dIn,
    input  [ADDR_WIDTH-1:0]  addr,
    output [DATA_WIDTH-1:0]  dOut
);

    localparam SIZE = 2**ADDR_WIDTH;
    reg [DATA_WIDTH-1:0] mem_content [SIZE-1:0];

    integer i;
    initial begin
        for (i = 0; i < SIZE; i = i + 1)
            mem_content[i] = {DATA_WIDTH{1'b0}};
    end

    always @(posedge clk) begin
        if (we)
            mem_content[addr] <= dIn;
    end

    assign dOut = mem_content[addr];

endmodule
