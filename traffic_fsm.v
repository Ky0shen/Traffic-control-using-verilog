module traffic_fsm(
    input  wire clk,
    input  wire reset,
    input  wire ped_req,
    input  wire tick_done,
    output reg  tick_start,
    output reg [1:0] tick_sel,
    output reg  ped_clear,
    output reg  ns_red,
    output reg  ns_yellow,
    output reg  ns_green,
    output reg  ew_red,
    output reg  ew_yellow,
    output reg  ew_green,
    output reg  ped_walk
);

    
    localparam S_NS_GREEN  = 7'b0000001;
    localparam S_NS_YELLOW = 7'b0000010;
    localparam S_ALL_RED_1 = 7'b0000100;
    localparam S_EW_GREEN  = 7'b0001000;
    localparam S_EW_YELLOW = 7'b0010000;
    localparam S_ALL_RED_2 = 7'b0100000;
    localparam S_PED       = 7'b1000000;

    reg [6:0] state, next_state;

   
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= S_NS_GREEN;
        else
            state <= next_state;
    end

    always @(*) begin
       
        ns_red    = 1'b0;
        ns_yellow = 1'b0;
        ns_green  = 1'b0;
        ew_red    = 1'b0;
        ew_yellow = 1'b0;
        ew_green  = 1'b0;
        ped_walk  = 1'b0;
        tick_start = 1'b0;
        tick_sel   = 2'b00; 
        ped_clear  = 1'b0;
        next_state = state;

        case (state)
            S_NS_GREEN: begin
                ns_green = 1'b1;
                ew_red   = 1'b1;
                tick_sel = 2'b00; 
                tick_start = (tick_done) ? 1'b1 : 1'b0;
                if (tick_done)
                    next_state = S_NS_YELLOW;
            end

            S_NS_YELLOW: begin
                ns_yellow = 1'b1;
                ew_red    = 1'b1;
                tick_sel  = 2'b01; 
                tick_start = (tick_done) ? 1'b1 : 1'b0;
                if (tick_done)
                    next_state = S_ALL_RED_1;
            end

            S_ALL_RED_1: begin
                ns_red = 1'b1;
                ew_red = 1'b1;
                
                if (ped_req)
                    next_state = S_PED;
                else
                    next_state = S_EW_GREEN;
            end

            S_EW_GREEN: begin
                ew_green = 1'b1;
                ns_red   = 1'b1;
                tick_sel = 2'b00; 
                tick_start = (tick_done) ? 1'b1 : 1'b0;
                if (tick_done)
                    next_state = S_EW_YELLOW;
            end

            S_EW_YELLOW: begin
                ew_yellow = 1'b1;
                ns_red    = 1'b1;
                tick_sel  = 2'b01; 
                tick_start = (tick_done) ? 1'b1 : 1'b0;
                if (tick_done)
                    next_state = S_ALL_RED_2;
            end

            S_ALL_RED_2: begin
                ns_red = 1'b1;
                ew_red = 1'b1;
                if (ped_req)
                    next_state = S_PED;
                else
                    next_state = S_NS_GREEN;
            end

            S_PED: begin
                ns_red   = 1'b1;
                ew_red   = 1'b1;
                ped_walk = 1'b1;
                tick_sel = 2'b10; // PED
                tick_start = (tick_done) ? 1'b1 : 1'b0;
                if (tick_done) begin
                    ped_clear  = 1'b1;
                    next_state = S_NS_GREEN; 
                end
            end

            default: begin
                next_state = S_NS_GREEN;
            end
        endcase
    end

endmodule
