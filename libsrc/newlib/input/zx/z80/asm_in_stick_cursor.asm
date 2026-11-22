
; ===============================================================
; 2014
; ===============================================================
; 
; uint16_t in_stick_cursor(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_cursor

asm_in_stick_cursor:

   ; exit : hl = F000RLDU active high
   ;
   ; uses : af, de, hl

   ld a,$f7
   in a,($fe)
   and $10
   
   push af

   ld a,$ef
   in a,($fe)
   and $1f
   
   ld e,a
   ld d,0
   ld hl,table
   add hl,de
   
   ld l,(hl)
   ld h,d

   pop af
   ret nz
   
   set 2,l
   ret

table:

   defb $8b,$0b,$8b,$0b
   defb $83,$03,$83,$03
   defb $8a,$0a,$8a,$0a
   defb $82,$02,$82,$02
   defb $89,$09,$89,$09
   defb $81,$01,$81,$01
   defb $88,$08,$88,$08
   defb $80,$00,$80,$00
