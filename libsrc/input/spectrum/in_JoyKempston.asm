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
   defb $70,$78,$74,$7c
   defb $72,$7a,$76,$7e
   defb $71,$79,$75,$7d
   defb $73,$7b,$77,$7f
   defb $f0,$f8,$f4,$fc
   defb $f2,$fa,$f6,$fe
   defb $f1,$f9,$f5,$fd
   defb $f3,$fb,$f7,$ff
