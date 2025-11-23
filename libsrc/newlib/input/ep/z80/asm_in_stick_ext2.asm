
; ===============================================================
; Aug 2015
; ===============================================================
; 
; uint16_t in_stick_ext2(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_ext2

EXTERN asm_in_stick_ext1_0

asm_in_stick_ext2:

   ; exit : hl = F000RLDU active high
   ;
   ; uses : af, bc, hl

   ld bc,$0409
   jp asm_in_stick_ext1_0
