SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC tshr_01_output_char_128_oterm_msg_scroll

EXTERN asm0_tshr_scroll_wc_up_pix
EXTERN zx_01_output_char_64_proc_stack_window_32

tshr_01_output_char_128_oterm_msg_scroll:

   ;   enter  :   c = number of rows to scroll
   ;   can use:  af, bc, de, hl
   ;
   ;   Scroll the window upward 'C' character rows.

   ld a,c                      ; a = number of rows to scroll
   
   call zx_01_output_char_64_proc_stack_window_32
   
   ; stack = window *

   add a,a
   add a,a
   add a,a
   
   ld e,a                      ; e = number of rows to scroll
   ld l,0
   
   push ix
   
   ld ix,2
   add ix,sp                   ; ix = window *
   
   call asm0_tshr_scroll_wc_up_pix
   
   pop ix
   
   pop hl
   pop hl                      ; junk window
   
   ret
