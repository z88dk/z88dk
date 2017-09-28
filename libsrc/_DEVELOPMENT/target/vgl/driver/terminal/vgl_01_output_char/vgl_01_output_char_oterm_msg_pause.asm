
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_char_oterm_msg_pause

EXTERN vgl_key_arm
EXTERN vgl_key_get
EXTERN vgl_key_peek

vgl_01_output_char_oterm_msg_pause:
   
   ;ret ; Do nothing, no pause
   
   ;@TODO: Show arrow symbol in a corner or something
   
   ; Wait for keypress
   ;	   ld a, 0xc0
   ;	   ld (__VGL_KEY_STATUS_ADDRESS), a	; Prepare next getkey
   ;	   
   ;	   ; Wait for key press
   ;	pause_getc_loop:
   ;	   
   ;	   ld a, (__VGL_KEY_STATUS_ADDRESS)
   ;	   cp 0xd0
   ;	   jr nz, pause_getc_loop
   
   call vgl_key_arm
   call vgl_key_get
   
   ret

