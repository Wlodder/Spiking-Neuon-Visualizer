module Neuron
#(parameter c_GAME_WIDTH = 640,
  parameter c_GAME_HEIGHT = 480)
(
    input i_Clk,
    input i_Action_Potential,
    input [9:0] i_Col_Count_Div,
    input [9:0] i_Row_Count_Div,
    
    output reg o_Membrane_Potential,
    output reg [9:0] o_Ball_X = 0,
    output o_Ball_Y);


parameter c_BALL_SPEED = 250000;
parameter c_BASE_CURRENT = 10;
parameter c_PSP_BASE = 440;
parameter c_THRESHOLD = 350;

integer i;

parameter MEM_SIZE = 23;

reg [9:0] r_Ball_X_old [MEM_SIZE:0];
reg [9:0] r_Ball_Y_old [MEM_SIZE:0];

reg [9:0] o_Ball_Y = c_PSP_BASE;

reg r_time_step_change = 0;

reg [31:0] r_Ball_Count = 0;

wire [9:0] w_Ball_Y;

always @(posedge i_Clk)
begin
    if(r_Ball_Count < c_BALL_SPEED)
    begin
        r_Ball_Count <= r_Ball_Count + 1;
        r_time_step_change <= 0;
    end
    else
    begin
        o_Ball_X <= o_Ball_X + 1;
        r_Ball_Count <= 0;
        r_time_step_change <= 1;

        for(i = 0; i < MEM_SIZE; i = i + 1)
        begin
            r_Ball_X_old[i] <= r_Ball_X_old[i+1];
            r_Ball_Y_old[i] <= r_Ball_Y_old[i+1];
        end

        r_Ball_X_old[MEM_SIZE] <= o_Ball_X;
        r_Ball_Y_old[MEM_SIZE] <= o_Ball_Y;
        if(o_Ball_X == c_GAME_WIDTH)
            o_Ball_X <= 0;
    end

end

Potential_Function #(.c_THRESHOLD(c_THRESHOLD)) Potential_Function_Inst
(.i_Clk(r_time_step_change),
 .i_Spike_Received(i_Action_Potential),
 .o_PSP_Trace(w_Ball_Y));


always @(posedge i_Clk)
begin
    o_Ball_Y <= c_PSP_BASE - w_Ball_Y;
    o_Membrane_Potential <= 1'b0;
    for(i = 0; i < MEM_SIZE ; i = i + 1)
    begin
        if((i_Col_Count_Div == r_Ball_X_old[i] && i_Row_Count_Div == r_Ball_Y_old[i]))
            o_Membrane_Potential <= 1'b1;

    end

    if ((i_Row_Count_Div == (c_PSP_BASE - c_THRESHOLD) && (i_Col_Count_Div[1] == 1'b0)) ||
        (i_Col_Count_Div == o_Ball_X && i_Row_Count_Div == o_Ball_Y))
        o_Membrane_Potential <= 1'b1;


end

endmodule