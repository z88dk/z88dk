SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC tshr_01_output_char_128_oterm_msg_cls

EXTERN asm_tshr_cls_wc_pix
EXTERN zx_01_output_char_64_proc_stack_window_32

tshr_01_output_char_128_oterm_msg_cls:

   call zx_01_output_char_64_proc_stack_window_32
   
   ; stack = window *

   push ix
   
   ld ix,2
   add ix,sp                   ; ix = window *
   
   ld l,0
   call asm_tshr_cls_wc_pix
   
   pop ix
   
   pop hl
   pop hl                      ; junk window

   ret
