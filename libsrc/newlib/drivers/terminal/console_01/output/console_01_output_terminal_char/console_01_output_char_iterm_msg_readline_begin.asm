
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_iterm_msg_readline_begin

console_01_output_char_iterm_msg_readline_begin:

   ; input terminal readline begins
   
   set 7,(ix+7)                ; indicates readline in progress
   ret
