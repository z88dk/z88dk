; uint in_JoySinclair1(void)
; 2002 aralbrec

SECTION code_clib
PUBLIC in_JoySinclair1
PUBLIC _in_JoySinclair1

; exit : HL = F000RLDU active high
; uses : AF,DE,HL

.in_JoySinclair1
._in_JoySinclair1
   ld a,$ef
   in a,($fe)
   and $1f
   ld e,a
   ld d,0
   ld hl,sinc1tbl
   add hl,de
   ld l,(hl)
   ld h,d
   ret

.sinc1tbl
   defb $8f,$0f,$8e,$0e
   defb $8d,$0d,$8c,$0c
   defb $87,$07,$86,$06
   defb $85,$05,$84,$04
   defb $8b,$0b,$8a,$0a
   defb $89,$09,$88,$08
   defb $83,$03,$82,$02
   defb $81,$01,$80,$00
