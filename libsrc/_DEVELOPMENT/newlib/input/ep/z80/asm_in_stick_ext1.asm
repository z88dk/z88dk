
; ===============================================================
; Aug 2015
; ===============================================================
; 
; uint16_t in_stick_ext1(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_ext1, asm_in_stick_ext1_0

asm_in_stick_ext1:

   ; exit : hl = F000RLDU active high
   ;
   ; uses : af, bc, hl

   ld bc,$0404

asm_in_stick_ext1_0:

   ld hl,0

loop:

   ld a,c
   dec c
   
   out ($b5),a
   in a,($b6)
      
   rra
   rl l
   
   djnz loop

   ld a,c
   out ($b5),a
   
   in a,($b6)
   rrca
   
   and $80
   or l
   cpl
   and $8f
   
   ld l,a
   ret
   