; uint in_JoyKempston(void)
; 2002 aralbrec

SECTION code_clib
PUBLIC in_JoyKempston
PUBLIC _in_JoyKempston

; exit : HL = F000RLDU active high
; uses : AF,DE,HL

.in_JoyKempston
._in_JoyKempston

   in a,($1f)
   and $1f
   ld e,a
   ld d,0
   ld hl,kemptbl
   add hl,de
   ld l,(hl)
   ld h,d
   ret

.kemptbl

   defb $00,$08,$04,$0c
   defb $02,$0a,$06,$0e
   defb $01,$09,$05,$0d
   defb $03,$0b,$07,$0f

   defb $80,$88,$84,$8c
   defb $82,$8a,$86,$8e
   defb $81,$89,$85,$8d
   defb $83,$8b,$87,$8f
