
; ===============================================================
; 2002
; ===============================================================
; 
; uint16_t in_stick_sinclair2(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_sinclair2

asm_in_stick_sinclair2:

   ; exit : hl = F000RLDU active high
   ;
   ; uses : af, de, hl
   
   ld a,$f7
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

   defb $8f,$8b,$87,$83
   defb $8d,$89,$85,$81
   defb $8e,$8a,$86,$82
   defb $8c,$88,$84,$80
   defb $0f,$0b,$07,$03
   defb $0d,$09,$05,$01
   defb $0e,$0a,$06,$02
   defb $0c,$08,$04,$00
