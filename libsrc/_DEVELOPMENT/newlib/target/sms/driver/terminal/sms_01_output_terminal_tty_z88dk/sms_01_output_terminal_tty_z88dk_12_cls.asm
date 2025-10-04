
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_12_cls

EXTERN sms_01_output_terminal_oterm_msg_cls
EXTERN sms_01_output_terminal_tty_z88dk_11_home

sms_01_output_terminal_tty_z88dk_12_cls:

   ; clear screen

   call sms_01_output_terminal_oterm_msg_cls
   ld (ix+20),0
   jp sms_01_output_terminal_tty_z88dk_11_home
