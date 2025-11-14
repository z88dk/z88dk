
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC sms_01_output_terminal_tty_z88dk_01_scroll

EXTERN console_01_output_char_proc_putchar_scroll_adjust

sms_01_output_terminal_tty_z88dk_01_scroll:

   ; scroll window upward one row
   
   ld a,1
   jp console_01_output_char_proc_putchar_scroll_adjust
