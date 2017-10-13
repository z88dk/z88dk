
INCLUDE "config_private.inc"

SECTION code_driver
SECTION code_driver_terminal_output

PUBLIC vgl_01_output_4000_oterm_msg_pause

;@FIXME: Just set it to vgl_01_input_4000_getc
vgl_01_output_4000_oterm_msg_pause:
   
   ;ret ; Do nothing, no pause
   
   ;@TODO: Show arrow symbol in a corner or something
   
   ; Wait for keypress
   ld a, 0xc0
   ld (__VGL_4000_KEY_STATUS_ADDRESS), a	; Prepare next getkey
      
   ; Wait for key press
   pause_getc_loop:
      ld a, (__VGL_4000_KEY_STATUS_ADDRESS)
      cp 0xd0
      jr nz, pause_getc_loop
   
   ret

