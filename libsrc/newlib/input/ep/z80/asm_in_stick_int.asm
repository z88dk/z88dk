
; ===============================================================
; Aug 2015
; ===============================================================
; 
; uint16_t in_stick_int(void)
;
; Return joystick state in byte FGHIRLDU active high.  The
; FGHI bits are fire buttons with "F" being primary.
;
; ===============================================================

SECTION code_clib
SECTION code_input

PUBLIC asm_in_stick_int

asm_int_stick_int:

   ; exit : hl = F000RLDU active high
   ;
   ; uses : af, de, hl

   ld a,7
   out ($b5),a

   in a,($b5)
   cpl
   and $2e
   ld e,a
      
   ; a = e = 00L0URD0 active high

   rlca
   rlca
   rlca
   or e
   and $0f
   ld e,a
   
   ; e = 0000URDL
   
   ld d,0
   ld hl,table
   add hl,de
   
   ld l,(hl)
   ld h,d
   
   ; hl = 0000RLDU active high
   
   ld a,8
   out ($b5),a
   
   in a,($b5)
   cpl
   and $40
   add a,a
   
   or l
   ld l,a
   
   ret

table:

   defb $00, $04, $02, $06, $08, $0c, $0a, $0e
   defb $01, $05, $03, $07, $09, $0d, $0b, $0f
