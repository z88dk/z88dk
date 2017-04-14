; ===============================================================
; Apr 2017
; ===============================================================
; 
; int in_test_key(void)
;
; Return true if a key is currently pressed.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_input

PUBLIC asm_in_test_key

asm_in_test_key:

   ; exit : nz flag set if a key is pressed
   ;         z flag set if no key is pressed
   ;
   ; uses : af
   
	push bc
	
	in a,(__IO_JOYSTICK_READ_L)
	
	and $30
	ld c,a
	
	in a,(__IO_JOYSTICK_READ_H)
	
	and $0c
	or c
	
	pop bc
   ret
