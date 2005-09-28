; uint in_JoyFuller(void)
; 2002 aralbrec

XLIB in_JoyFuller

; exit : A = HL= F111RLDU active low
; uses : AF,HL

.in_JoyFuller
   in a,($7f)
   or $70
   ld l,a
   ld h,0
   ret
