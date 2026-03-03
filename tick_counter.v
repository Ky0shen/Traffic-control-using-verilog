
module tick_counter(
    input  wire clk,
    input  wire reset,
    input  wire start,
    input  wire [15:0] target_ticks,
    output reg  done
);
    reg [15:0] count;
    reg        active;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count  <= 16'd0;
            active <= 1'b0;
            done   <= 1'b0;
        end else begin
            done <= 1'b0;
            if (start) begin
                active <= 1'b1;
                count  <= 16'd0;
            end else if (active) begin
                if (count == target_ticks - 1) begin
                    active <= 1'b0;
                    done   <= 1'b1;
                end else begin
                    count <= count + 1'b1;
                end
            end
        end
    end
endmodule

