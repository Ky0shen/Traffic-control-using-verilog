module ped_request_latch(
    input  wire clk,
    input  wire reset,
    input  wire ped_btn,
    input  wire ped_clear,
    output reg  ped_req
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ped_req <= 1'b0;
        end else begin
            if (ped_btn)
                ped_req <= 1'b1;
            else if (ped_clear)
                ped_req <= 1'b0;
        end
    end
endmodule
