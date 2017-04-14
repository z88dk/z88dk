; ===============================================================
; 2017
; ===============================================================
; 
; uint16_t in_stick_1(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_1
PUBLIC asm_in_stick_1_0

asm_in_stick_1:

   ; exit : hl = FG00RLDU active high
   ;
   ; uses : af, hl
   
   in a,(__IO_JOYSTICK_READ_L)

asm_in_stick_1_0:

   ld h,a
   
   and $0f
   ld l,a
   
   ld a,h
   rla
   rla
   and $c0
   
   or l
   ld l,a
   
   ld h,0
   ret
