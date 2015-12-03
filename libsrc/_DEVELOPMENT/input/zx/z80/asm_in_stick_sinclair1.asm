
; ===============================================================
; 2002
; ===============================================================
; 
; uint16_t in_stick_sinclair1(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_sinclair1

asm_in_stick_sinclair1:

   ; exit : hl = F000RLDU active high
   ;
   ; uses : af, de, hl
   
   ld a,$ef
   in a,($fe)
   and $1f
   
   ld e,a
   ld d,0
   ld hl,table
   add hl,de
   
   ld l,(hl)
   ld h,d

   ret

table:

   defb $8f,$0f,$8e,$0e
   defb $8d,$0d,$8c,$0c
   defb $87,$07,$86,$06
   defb $85,$05,$84,$04
   defb $8b,$0b,$8a,$0a
   defb $89,$09,$88,$08
   defb $83,$03,$82,$02
   defb $81,$01,$80,$00
