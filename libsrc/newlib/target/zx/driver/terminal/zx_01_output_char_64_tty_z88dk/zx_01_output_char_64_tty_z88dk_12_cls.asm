
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_64_tty_z88dk_12_cls

EXTERN zx_01_output_char_64_oterm_msg_cls
EXTERN console_01_output_char_proc_reset_scroll_limit
EXTERN zx_01_output_char_32_tty_z88dk_11_home

zx_01_output_char_64_tty_z88dk_12_cls:

   ; clear screen

   call zx_01_output_char_64_oterm_msg_cls
   ld (ix+20),0
   jp zx_01_output_char_32_tty_z88dk_11_home
