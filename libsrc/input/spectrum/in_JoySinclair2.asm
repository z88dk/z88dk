; uint in_JoySinclair2(void)
; 2002 aralbrec

XLIB in_JoySinclair2

; exit : HL = F111RLDU active low
; uses : AF,DE,HL

.in_JoySinclair2
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
   defb $70,$74,$78,$7c
   defb $72,$76,$7a,$7e
   defb $71,$75,$79,$7d
   defb $73,$77,$7b,$7f
   defb $f0,$f4,$f8,$fc
   defb $f2,$f6,$fa,$fe
   defb $f1,$f5,$f9,$fd
   defb $f3,$f7,$fb,$ff
