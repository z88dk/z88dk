
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_01_scroll

EXTERN console_01_output_char_proc_putchar_scroll_adjust

zx_01_output_char_32_tty_z88dk_01_scroll:

   ; scroll window upward one row
   
   ld a,1
   jp console_01_output_char_proc_putchar_scroll_adjust
