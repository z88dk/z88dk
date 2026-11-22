
SECTION code_driver
SECTION code_driver_terminal_input

PUBLIC cpm_01_input_kbd_dcio_stdio_msg_flsh

EXTERN __CPM_DCIO
EXTERN asm_cpm_bdos_alt, console_01_input_stdio_msg_flsh

;;defc cpm_01_input_kbd_dcio_stdio_msg_flsh = console_01_input_stdio_msg_flsh

cpm_01_input_kbd_dcio_stdio_msg_flsh:
 
   ; get rid of any pending chars in bdos
   ; (What if someone is holding down a key?)
   
   ld c,__CPM_DCIO             ; direct console i/o
   ld e,0xff                   ; input
   call asm_cpm_bdos_alt
   
   or a
   jr nz, cpm_01_input_kbd_dcio_stdio_msg_flsh

   jp console_01_input_stdio_msg_flsh
