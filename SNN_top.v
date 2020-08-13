module SNN_top
(
    input i_Clk,
    
    // Push Buttons
    input i_Switch_1,

    // VGA
    output o_VGA_HSync,
    output o_VGA_VSync,
    output o_VGA_Red_0,
    output o_VGA_Red_1,
    output o_VGA_Red_2,
    output o_VGA_Grn_0,
    output o_VGA_Grn_1,
    output o_VGA_Grn_2,
    output o_VGA_Blu_0,
    output o_VGA_Blu_1,
    output o_VGA_Blu_2);

// VGA Constants to Set Frame Size
parameter c_VIDEO_WIDTH = 3;
parameter c_TOTAL_COLS = 800;
parameter c_TOTAL_ROWS = 525;
parameter c_ACTIVE_COLS = 640;
parameter c_ACTIVE_ROWS = 480;


// Common VGA Signals 
wire [c_VIDEO_WIDTH-1:0] w_Red_Video_Membrane, w_Red_Video_Porch;
wire [c_VIDEO_WIDTH-1:0] w_Grn_Video_Membrane, w_Grn_Video_Porch;
wire [c_VIDEO_WIDTH-1:0] w_Blu_Video_Membrane, w_Blu_Video_Porch;

wire w_Switch_1;

VGA_Sync_Pulses #(.TOTAL_COLS(c_TOTAL_COLS),
                  .TOTAL_ROWS(c_TOTAL_ROWS),
                  .ACTIVE_COLS(c_ACTIVE_COLS),
                  .ACTIVE_ROWS(c_ACTIVE_ROWS)) VGA_Sync_Pulses_Inst
(.i_Clk(i_Clk),
 .o_HSync(w_HSync_VGA),
 .o_VSync(w_VSync_VGA),
 .o_Col_Count(),
 .o_Row_Count());

Debounce_Switch Switch_1
(.i_Clk(i_Clk),
 .i_Switch(i_Switch_1),
 .o_Switch(w_Switch_1));

SNN #(.c_TOTAL_COLS(c_TOTAL_COLS),
      .c_TOTAL_ROWS(c_TOTAL_ROWS),
      .c_ACTIVE_COLS(c_ACTIVE_COLS),
      .c_ACTIVE_ROWS(c_ACTIVE_ROWS)) SNN_Inst
(.i_Clk(i_Clk),
 .i_HSync(w_HSync_VGA),
 .i_VSync(w_VSync_VGA),
 .i_Action_Potential(w_Switch_1),
 .o_HSync(w_HSync_SNN),
 .o_VSync(w_VSync_SNN),
 .o_Red_Video(w_Red_Video_Membrane),
 .o_Grn_Video(w_Grn_Video_Membrane),
 .o_Blu_Video(w_Blu_Video_Membrane));

VGA_Sync_Porch #(.VIDEO_WIDTH(c_VIDEO_WIDTH),
                 .TOTAL_COLS(c_TOTAL_COLS),
                 .TOTAL_ROWS(c_TOTAL_ROWS),
                 .ACTIVE_COLS(c_ACTIVE_COLS),
                 .ACTIVE_ROWS(c_ACTIVE_ROWS))
VGA_Sync_Porch_Inst
(.i_Clk(i_Clk),
 .i_HSync(w_HSync_SNN),
 .i_VSync(w_VSync_SNN),
 .i_Red_Video(w_Red_Video_Membrane),
 .i_Grn_Video(w_Grn_Video_Membrane),
 .i_Blu_Video(w_Blu_Video_Membrane),
 .o_HSync(o_VGA_HSync),
 .o_VSync(o_VGA_VSync),
 .o_Red_Video(w_Red_Video_Porch),
 .o_Grn_Video(w_Grn_Video_Porch),
 .o_Blu_Video(w_Blu_Video_Porch));


assign o_VGA_Red_0 = w_Red_Video_Porch[0];
assign o_VGA_Red_1 = w_Red_Video_Porch[1];
assign o_VGA_Red_2 = w_Red_Video_Porch[2];

assign o_VGA_Grn_0 = w_Grn_Video_Porch[0];
assign o_VGA_Grn_1 = w_Grn_Video_Porch[1];
assign o_VGA_Grn_2 = w_Grn_Video_Porch[2];

assign o_VGA_Blu_0 = w_Blu_Video_Porch[0];
assign o_VGA_Blu_1 = w_Blu_Video_Porch[1];
assign o_VGA_Blu_2 = w_Blu_Video_Porch[2];

endmodule