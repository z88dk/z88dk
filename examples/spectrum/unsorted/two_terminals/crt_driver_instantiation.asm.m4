   ;# DRIVER INSTANTIATION
   ;# sets up an input terminal and two fzx output terminals
   ;# the input terminal is connected to fd=1 ("__i_fcntl_fdstruct_1")
   
   ;# Many of the user-definable characteristics of the drivers are retained
   ;# so that these drivers can still be customized by many of the existing pragmas.

   ;# fd=0, stdin
   
   include(`driver/terminal/zx_01_input_kbd_inkey.m4')dnl
   m4_zx_01_input_kbd_inkey(_stdin, __i_fcntl_fdstruct_1, CRT_ITERM_TERMINAL_FLAGS, M4__CRT_ITERM_EDIT_BUFFER_SIZE, CRT_ITERM_INKEY_DEBOUNCE, CRT_ITERM_INKEY_REPEAT_START, CRT_ITERM_INKEY_REPEAT_RATE)dnl

   ;# fd=1, window_1

   EXTERN _ff_ao_Prefect
   
   include(`driver/terminal/zx_01_output_fzx.m4')dnl
   m4_zx_01_output_fzx(_window_1, 0x2330, 0, 0, 1, 14, 1, 19, 0, _ff_ao_Prefect, 14, 0, 14, 8, 112, 8, 152, M4__CRT_OTERM_FZX_DRAW_MODE, CRT_OTERM_FZX_LINE_SPACING, CRT_OTERM_FZX_LEFT_MARGIN, CRT_OTERM_FZX_SPACE_EXPAND)dnl
   
   ;# fd=2, window_2
   
   EXTERN _ff_ao_RoundelSerif
   
   include(`driver/terminal/zx_01_output_fzx.m4')dnl
   m4_zx_01_output_fzx(_window_2, 0x2330, 0, 0, 16, 14, 3, 19, 0, _ff_ao_RoundelSerif, 26, 0, 26, 128, 112, 24, 152, M4__CRT_OTERM_FZX_DRAW_MODE, CRT_OTERM_FZX_LINE_SPACING, CRT_OTERM_FZX_LEFT_MARGIN, CRT_OTERM_FZX_SPACE_EXPAND)dnl
