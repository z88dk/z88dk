
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_fzx_tty_z88dk_12_cls

EXTERN zx_01_output_fzx_oterm_msg_cls
EXTERN zx_01_output_fzx_tty_z88dk_11_home

zx_01_output_fzx_tty_z88dk_12_cls:

   ; clear screen

   call zx_01_output_fzx_oterm_msg_cls
   ld (ix+20),0
   jp zx_01_output_fzx_tty_z88dk_11_home
