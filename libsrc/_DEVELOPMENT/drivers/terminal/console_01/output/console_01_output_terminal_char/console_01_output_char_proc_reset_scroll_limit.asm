
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_proc_reset_scroll_limit

console_01_output_char_proc_reset_scroll_limit:

   ; set scroll limit to window height
   
   ld a,(ix+19)                ; a = rect.height
   ld (ix+20),a
   
   ret
