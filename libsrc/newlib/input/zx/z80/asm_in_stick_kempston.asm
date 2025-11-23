
; ===============================================================
; 2002
; ===============================================================
; 
; uint16_t in_stick_kempston(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_kempston

asm_in_stick_kempston:

   ; exit : hl = F000RLDU active high
   ;
   ; uses : af, de, hl
   
   in a,($1f)
   and $1f
   
   ld e,a
   ld d,0
   ld hl,table
   add hl,de
   
   ld l,(hl)
   ld h,d
   
   ret

table:

   defb $00,$08,$04,$0c
   defb $02,$0a,$06,$0e
   defb $01,$09,$05,$0d
   defb $03,$0b,$07,$0f

   defb $80,$88,$84,$8c
   defb $82,$8a,$86,$8e
   defb $81,$89,$85,$8d
   defb $83,$8b,$87,$8f
