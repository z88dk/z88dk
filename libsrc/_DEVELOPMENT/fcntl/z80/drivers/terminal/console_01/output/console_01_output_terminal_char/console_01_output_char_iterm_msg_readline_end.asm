
SECTION seg_code_fcntl

PUBLIC console_01_output_char_iterm_msg_readline_end

EXTERN console_01_output_char_proc_reset_scroll_limit

console_01_output_char_iterm_msg_readline_end:

   ; input terminal readline ends
   
   res 7,(ix+7)                ; indicate readline not in progress
   jp console_01_output_char_proc_reset_scroll_limit
