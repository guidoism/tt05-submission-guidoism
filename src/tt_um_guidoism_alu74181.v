`timescale 1ns / 1ps
`default_nettype none

module tt_um_guidoism_alu74181 (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    ALU74181 alu (
        .a(ui_in[3:0]),
        .b(ui_in[7:4]),
        .s(uio_in[3:0]),
        .m(uio_in[4]),
        .notc(uio_in[5]),
        .f(uo_out[3:0]),
        .eql(uo_out[4]),
        .cout(uo_out[5]),
        .pout(uo_out[6]),
        .gout(uo_out[7])
    );

    assign uio_oe = 8'b11111111;  // This sets all IOs to be outputs. Adjust accordingly.
    

endmodule
