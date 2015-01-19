; uint in_JoyFuller(void)
; 2002 aralbrec

PUBLIC in_JoyFuller

; exit : A = HL= F000RLDU active high
; uses : AF,HL

.in_JoyFuller
   in a,($7f)
   cpl
   and $8f
   ld l,a
   ld h,0
   ret
