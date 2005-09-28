; char *in_JoyEnumQuery(uchar i)
; 09.2005 aralbrec

XLIB in_JoyEnumQuery

.in_JoyEnumQuery
   ld a,l
   cp 7
   jr c, inrange
   ld hl,0
   ret
.inrange
   add a,a
   ld l,a
   ld h,0
   ld de,table
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl
   ret

j0: defm "keyboard"&0
j1: defm "kempston"&0
j2: defm "sinclair 1"&0
j3: defm "sinclair 2"&0
j4: defm "fuller"&0
j5: defm "timex 1"&0
j6: defm "timex 2"&0&0

.table
   defw j0,j1,j2,j3,j4,j5,j6

