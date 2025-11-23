
; ===============================================================
; 2002
; ===============================================================
; 
; uint16_t in_stick_fuller(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_fuller

asm_in_stick_fuller:

   ; exit : hl = F000RLDU active high
   ;
   ; uses : af, hl
   
   in a,($7f)
   cpl
   and $8f
   
   ld l,a
   ld h,0

   ret
