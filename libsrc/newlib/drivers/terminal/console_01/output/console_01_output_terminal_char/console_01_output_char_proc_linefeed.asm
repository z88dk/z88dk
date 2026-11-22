
SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC console_01_output_char_proc_linefeed

EXTERN console_01_output_char_proc_putchar_scroll

console_01_output_char_proc_linefeed:

   ; ix = FDSTRUCT.JP *

   ld d,(ix+15)
   inc d                       ; d = y++
   
   ld a,d
   sub (ix+19)
   
   jr c, y_ok_2
   
   inc a
   call console_01_output_char_proc_putchar_scroll

   ld d,(ix+19)
   dec d                       ; d = y = window.height - 1
   
   jr nc, y_ok_2               ; if no cls
   
   ld d,0

y_ok_2:

   ld (ix+14),0                ; x = 0
   ld (ix+15),d                ; set new y coord
   
   ret
