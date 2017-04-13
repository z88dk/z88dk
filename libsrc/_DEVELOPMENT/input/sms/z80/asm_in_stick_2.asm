; ===============================================================
; 2017
; ===============================================================
; 
; uint16_t in_stick_2(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_2

EXTERN asm_in_stick_1_0

asm_in_stick_2:

   ; exit : hl = FG00RLDU active high
   ;
   ; uses : af, hl
   
   in a,(__IO_JOYSTICK_READ_L)
   ld h,a
   
   in a,(__IO_JOYSTICK_READ_H)
   
   rl h
   rla
   rl h
   rla
   
   jp asm_in_stick_1_0
