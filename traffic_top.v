module traffic_top #(
    parameter GREEN_TICKS  = 16'd1000,
    parameter YELLOW_TICKS = 16'd300,
    parameter PED_TICKS    = 16'd800
)(
    input  wire clk,
    input  wire reset,
    input  wire ped_btn,
    output wire ns_red,
    output wire ns_yellow,
    output wire ns_green,
    output wire ew_red,
    output wire ew_yellow,
    output wire ew_green,
    output wire ped_walk
);
    wire ped_req;
    wire ped_clear;
    wire tick_start;
    wire tick_done;
    wire [1:0] tick_sel; // 00=GREEN, 01=YELLOW, 10=PED

    reg [15:0] tick_target;

    always @(*) begin
        case (tick_sel)
            2'b00: tick_target = GREEN_TICKS;
            2'b01: tick_target = YELLOW_TICKS;
            2'b10: tick_target = PED_TICKS;
            default: tick_target = GREEN_TICKS;
        endcase
    end

    
    ped_request_latch ped_latch_inst (
        .clk      (clk),
        .reset    (reset),
        .ped_btn  (ped_btn),
        .ped_clear(ped_clear),
        .ped_req  (ped_req)
    );

    
    tick_counter tick_inst (
        .clk         (clk),
        .reset       (reset),
        .start       (tick_start),
        .target_ticks(tick_target),
        .done        (tick_done)
    );

    

    traffic_fsm fsm_inst (
        .clk       (clk),
        .reset     (reset),
        .ped_req   (ped_req),
        .tick_done (tick_done),
        .tick_start(tick_start),
        .tick_sel  (tick_sel),
        .ped_clear (ped_clear),
        .ns_red    (ns_red),
        .ns_yellow (ns_yellow),
        .ns_green  (ns_green),
        .ew_red    (ew_red),
        .ew_yellow (ew_yellow),
        .ew_green  (ew_green),
        .ped_walk  (ped_walk)
    );

endmodule

