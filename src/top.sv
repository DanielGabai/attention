`timescale 1ns/1ps

module top #(
    parameter N = 4; // sequence length
    parameter D = 8; // dimension size
    parameter B = 8; // int8 format
)(
    input logic clk,
    input logic rst_n, // used to doing it this way, could also just be rst

    // val/rdy handshake
    input logic input_val, // high if data is ready to come in
    output logic input_rdy, // high if module is ready to accept new data
    output logic output_val, // high if module has data to be sent
    input logic output_rdy, // high if reciever is ready to recieve

    input logic [B*D-1:0] input, // B*D = 64 by default
    output logic [B*D-1:0] output // The updated embedding
);

    typedef enum logic [2:0] {  
        IDLE,
        INPUTTING,
        OUTPUT,
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            state <= IDLE;
        end
    end

    always_comb begin
        next_state = state;
    end

    assign input_rdy = (state == IDLE);
    assign output_val = (state == OUTPUT);

endmodule