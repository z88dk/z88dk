; uint in_JoyKempston(void)
; 2002 aralbrec

XLIB in_JoyKempston

; exit : HL = F111RLDU active low
; uses : AF,DE,HL

.in_JoyKempston
   in a,($1f)
   cpl
   and $1f
   ld e,a
   ld d,0
   ld hl,kemptbl
   add hl,de
   ld l,(hl)
   ld h,d
   ret

.kemptbl
   defb $8f,$87,$8b,$83
   defb $82,$8a,$86,$8e
   defb $81,$89,$85,$8d
   defb $8c,$84,$88,$80
   defb $0f,$07,$0b,$03
   defb $0d,$05,$09,$01
   defb $0e,$06,$0a,$02
   defb $02,$04,$08,$00
