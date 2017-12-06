   ;# DRIVER INSTANTIATION
   ;# sets up two fzx output terminals
   
   ;# Many of the user-definable characteristics of the drivers are retained
   ;# so that these drivers can still be customized by many of the existing pragmas.

   ;# fd=0, stdin
   
   include(`../m4_file_absent.m4')dnl
   m4_file_absent

   ;# fd=1, window_1, (x,width,y,height) = (2,28,2,16) in 64-col chars

   EXTERN _ff_ao_Hiroshi
   
   include(`tshr_01_output_fzx_smooth_scroll.m4')dnl
   m4_tshr_01_output_fzx_smooth_scroll(_window_1, 0x2330, 0, 0, 2, 28, 2, 16, 0, _ff_ao_Hiroshi, 16, 224, 16, 128, M4__CRT_OTERM_FZX_DRAW_MODE, CRT_OTERM_FZX_LINE_SPACING, CRT_OTERM_FZX_LEFT_MARGIN, CRT_OTERM_FZX_SPACE_EXPAND)dnl
   
   ;# fd=2, window_2 (x,width,y,height) = (32,28,5,16) in 64-col chars
   
   EXTERN _ff_ao_Twombly
   
   include(`tshr_01_output_fzx_smooth_scroll.m4')dnl
   m4_tshr_01_output_fzx_smooth_scroll(_window_2, 0x2330, 0, 0, 32, 28, 5, 16, 0, _ff_ao_Twombly, 256, 224, 40, 128, M4__CRT_OTERM_FZX_DRAW_MODE, CRT_OTERM_FZX_LINE_SPACING, CRT_OTERM_FZX_LEFT_MARGIN, CRT_OTERM_FZX_SPACE_EXPAND)dnl
