
SECTION code_fcntl

PUBLIC zx_01_output_char_64_tty_11_scroll

EXTERN zx_01_output_char_64_oterm_msg_scroll

zx_01_output_char_64_tty_11_scroll:

   ; scroll window upward one row
   
   ; should we be changing current cursor coordinate ???
   
   ld c,1
   jp zx_01_output_char_64_oterm_msg_scroll
