
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_64_oterm_msg_cls

EXTERN asm_zx_cls_wc
EXTERN zx_01_output_char_64_proc_stack_window_32

zx_01_output_char_64_oterm_msg_cls:

   call zx_01_output_char_64_proc_stack_window_32
   
   ; stack = window *
   
   ld l,(ix+25)                ; l = background colour
   
   push ix
   
   ld ix,2
   add ix,sp                   ; ix = window *
   
   call asm_zx_cls_wc
   
   pop ix
   
   pop hl
   pop hl                      ; junk window

   ret
