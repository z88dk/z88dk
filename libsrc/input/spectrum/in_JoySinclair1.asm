; uint in_JoySinclair1(void)
; 2002 aralbrec

XLIB in_JoySinclair1

; exit : HL = F111RLDU active low
; uses : AF,DE,HL

.in_JoySinclair1
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
   defb $70,$f0,$71,$f1
   defb $72,$f2,$73,$f3
   defb $78,$f8,$79,$f9
   defb $7a,$fa,$7b,$fb
   defb $74,$f4,$75,$f5
   defb $76,$f6,$77,$f7
   defb $7c,$fc,$7d,$fd
   defb $7e,$fe,$7f,$ff
