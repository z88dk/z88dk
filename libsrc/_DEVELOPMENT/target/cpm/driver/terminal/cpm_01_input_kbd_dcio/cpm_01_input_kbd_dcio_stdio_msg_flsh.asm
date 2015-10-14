
SECTION code_fcntl

PUBLIC cpm_01_input_kbd_dcio_stdio_msg_flsh

EXTERN console_01_input_stdio_msg_flsh

defc cpm_01_input_kbd_dcio_stdio_msg_flsh = console_01_input_stdio_msg_flsh

; cpm_01_input_kbd_dcio_stdio_msg_flsh:
; 
;    ; get rid of any pending chars in cpm
;    ; (What if someone is holding down a key? That's why this is not being used)
;    
;    call asm_in_wait_nokey
;    jp console_01_input_stdio_msg_flsh
