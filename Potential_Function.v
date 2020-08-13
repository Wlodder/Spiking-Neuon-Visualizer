module Potential_Function #(parameter c_THRESHOLD = 500)
(input i_Clk,
 input i_Spike_Received,
 output reg [9:0] o_PSP_Trace = 100);

parameter BASE = 100;
parameter FREE = 0;
parameter REFACTORY = 1;
reg r_STATE = 0;

always @(posedge i_Clk)
begin
    case(r_STATE)
    
    FREE:
    begin
        if(o_PSP_Trace == c_THRESHOLD)
        begin
            r_STATE <= REFACTORY;
        end
        else
        begin
            o_PSP_Trace <= o_PSP_Trace + ((i_Spike_Received) ? ((o_PSP_Trace >> 5) ? (o_PSP_Trace >> 5) : 1) : -(o_PSP_Trace >> 4));
            r_STATE <= FREE;
        end
    end

    REFACTORY:
    begin
        if(o_PSP_Trace > BASE)
        begin
            o_PSP_Trace <= o_PSP_Trace + ((o_PSP_Trace >> 4) ? -(o_PSP_Trace >> 5) : -1);
            r_STATE <= REFACTORY;
        end
        else
        begin
            r_STATE <= FREE;
        end
    end

    endcase
end

endmodule