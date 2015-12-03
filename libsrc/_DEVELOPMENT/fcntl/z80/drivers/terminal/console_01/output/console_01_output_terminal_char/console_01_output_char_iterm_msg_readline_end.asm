
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_iterm_msg_readline_end

console_01_output_char_iterm_msg_readline_end:

   ; input terminal readline ends
   
   res 7,(ix+7)                ; indicate readline not in progress
   
   ; number of allowed scrolls set to current y coordinate plus one
   
   ld a,(ix+15)                ; a = y coord
   inc a
   ld (ix+20),a
   
   ret
