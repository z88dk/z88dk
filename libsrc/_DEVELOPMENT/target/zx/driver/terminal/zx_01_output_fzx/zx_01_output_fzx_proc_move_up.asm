
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_proc_move_up

EXTERN console_01_output_char_proc_move_up
EXTERN zx_01_output_fzx_proc_move_up_down

zx_01_output_fzx_proc_move_up:

   ; variable width fonts confuse the meaning of left, right, up, down movement
   ; so for fzx these movements are defined in terms of the native fixed width char size
   ;
   ; move character coordinates down one row, snap to window
   ;
   ; uses : af, b, d, hl

   ld hl,console_01_output_char_proc_move_up
   push hl
   
   jp zx_01_output_fzx_proc_move_up_down
