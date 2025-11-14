
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_proc_move_right

EXTERN zx_01_output_fzx_proc_move_left_right
EXTERN console_01_output_char_proc_move_right

zx_01_output_fzx_proc_move_right:

   ; variable width fonts confuse the meaning of left, right, up, down movement
   ; so for fzx these movements are defined in terms of the native fixed width char size
   ;
   ; move right, wrap, snap to window
   ;
   ; uses : af, b, de, hl

   ld hl,console_01_output_char_proc_move_right
   push hl
   
   jp zx_01_output_fzx_proc_move_left_right
