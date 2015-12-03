
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_64_oterm_msg_scroll

EXTERN asm_zx_scroll_wc_up_noexx
EXTERN zx_01_output_char_64_proc_stack_window_32

zx_01_output_char_64_oterm_msg_scroll:

   ;   enter  :   c = number of rows to scroll
   ;   can use:  af, bc, de, hl
   ;
   ;   Scroll the window upward 'L' character rows.

   ld a,c                      ; a = number of rows to scroll
   
   call zx_01_output_char_64_proc_stack_window_32
   
   ; stack = window *

   ld e,a
   ld d,0                      ; de = number of rows to scroll
   
   ld l,(ix+25)                ; l = background colour
   
   push ix
   
   ld ix,2
   add ix,sp                   ; ix = window *
   
   call asm_zx_scroll_wc_up_noexx
   
   pop ix
   
   pop hl
   pop hl                      ; junk window
   
   ret
