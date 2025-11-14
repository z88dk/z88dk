
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC zx_01_output_char_32_tty_z88dk_09_tab

EXTERN console_01_output_char_proc_linefeed

zx_01_output_char_32_tty_z88dk_09_tab:

   ; tab to next multiple of eight column
   
   ; should we be printing spaces to the next tab ??
   
   ld a,(ix+14)                ; a = x coord
   
   and $f8
   add a,$08
   
   jp c, console_01_output_char_proc_linefeed
   
   ld (ix+14),a                ; store new x coord
   
   cp (ix+17)
   ret c                       ; if x < width
   
   jp console_01_output_char_proc_linefeed
