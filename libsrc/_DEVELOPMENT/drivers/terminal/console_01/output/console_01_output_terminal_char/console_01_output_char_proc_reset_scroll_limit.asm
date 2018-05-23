
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_proc_reset_scroll_limit

EXTERN l_jpix
EXTERN OTERM_MSG_SCROLL_LIMIT

console_01_output_char_proc_reset_scroll_limit:

   ; set scroll limit to window height
   
   ld c,(ix+19)                ; a = rect.height
   
   ld a,OTERM_MSG_SCROLL_LIMIT
   call l_jpix
   
   ld (ix+20),c
   ret
