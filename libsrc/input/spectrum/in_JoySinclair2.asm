; uint in_JoySinclair2(void)
; 2002 aralbrec

SECTION code_clib
PUBLIC in_JoySinclair2
PUBLIC _in_JoySinclair2

; exit : HL = F000RLDU active high
; uses : AF,DE,HL

.in_JoySinclair2
._in_JoySinclair2
   ld a,$f7
   in a,($fe)
   and $1f
   ld e,a
   ld d,0
   ld hl,sinc2tbl
   add hl,de
   ld l,(hl)
   ld h,d
   ret

.sinc2tbl
   defb $8f,$8b,$87,$83
   defb $8d,$89,$85,$81
   defb $8e,$8a,$86,$82
   defb $8c,$88,$84,$80
   defb $0f,$0b,$07,$03
   defb $0d,$09,$05,$01
   defb $0e,$0a,$06,$02
   defb $0c,$08,$04,$00
