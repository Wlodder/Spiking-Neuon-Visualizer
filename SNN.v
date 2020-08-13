module SNN
#(parameter c_TOTAL_COLS = 800,
  parameter c_TOTAL_ROWS = 525,
  parameter c_ACTIVE_COLS = 640,
  parameter c_ACTIVE_ROWS = 480)
(input i_Clk,
 input i_HSync,
 input i_VSync,

 // Button to determine whether Spike is being received
 input i_Action_Potential,

 // Output Video
 output reg o_HSync, 
 output reg o_VSync,
 output [3:0] o_Red_Video,
 output [3:0] o_Grn_Video,
 output [3:0] o_Blu_Video);

// Local Constants to Determine Game Play
parameter c_GAME_WIDTH = 640;
parameter c_GAME_HEIGHT = 480;
parameter c_PULSE_BASE = 20;

// State machine enumerations
parameter IDLE = 1'b0;
parameter RUNNING = 1'b1;

reg r_SM_Main = RUNNING;

wire w_HSync, w_VSync;
wire [9:0] w_Col_Count, w_Row_Count;

wire w_Draw_All;

wire w_Draw_Ball;
wire [9:0] w_Ball_X, w_Ball_Y;

// Divided version of the Row/Col Counters
// Allows us to make the board 80x60
wire [9:0] w_Col_Count_Div, w_Row_Count_Div;

Sync_To_Count #(.TOTAL_COLS(c_TOTAL_COLS),
                .TOTAL_ROWS(c_TOTAL_ROWS)) Sync_To_Count_Inst
(.i_Clk(i_Clk),
 .i_HSync(i_HSync),
 .i_VSync(i_VSync),
 .o_HSync(w_HSync),
 .o_VSync(w_VSync),
 .o_Col_Count(w_Col_Count),
 .o_Row_Count(w_Row_Count));

// Register syncs to align with output data
always @(posedge i_Clk)
begin
    o_HSync <= w_HSync;
    o_VSync <= w_VSync;
end

assign w_Col_Count_Div = w_Col_Count;
assign w_Row_Count_Div = w_Row_Count;

Neuron #(.c_GAME_WIDTH(c_GAME_WIDTH),
         .c_GAME_HEIGHT(c_GAME_HEIGHT)) Neuron_Inst
(.i_Clk(i_Clk),
 .i_Action_Potential(i_Action_Potential),
 .i_Col_Count_Div(w_Col_Count_Div),
 .i_Row_Count_Div(w_Row_Count_Div),
 .o_Membrane_Potential(w_Draw_Ball),
 .o_Ball_X(w_Ball_X),
 .o_Ball_Y(w_Ball_Y));

assign w_Game_Active = (r_SM_Main == RUNNING) ? 1'b1 : 1'b0;

assign w_Draw_All = w_Draw_Ball;

assign o_Red_Video = w_Draw_All ? 4'b1111 : 4'b0000;
assign o_Grn_Video = w_Draw_All ? 4'b1111 : 4'b0000;
assign o_Blu_Video = w_Draw_All ? 4'b1111 : 4'b0000;

endmodule