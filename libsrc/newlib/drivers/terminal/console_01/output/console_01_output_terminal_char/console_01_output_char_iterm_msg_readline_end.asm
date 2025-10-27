
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_iterm_msg_readline_end

EXTERN l_jpix
EXTERN ITERM_MSG_READLINE_SCROLL_LIMIT

console_01_output_char_iterm_msg_readline_end:

   ; input terminal readline ends
   
   res 7,(ix+7)                ; indicate readline not in progress
   
   ; number of allowed scrolls set to current y coordinate plus one
   
   ld c,(ix+15)                ; c = y coord
   inc c
   
   ld a,ITERM_MSG_READLINE_SCROLL_LIMIT
   call l_jpix

   ld (ix+20),c   
   ret
