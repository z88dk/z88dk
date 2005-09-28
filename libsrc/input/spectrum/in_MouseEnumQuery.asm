; char *in_MouseEnumQuery(uchar i)
; 09.2005 aralbrec

XLIB in_MouseEnumQuery

.in_MouseEnumQuery
   ld a,l
   cp 3
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

m0: defm "simulated"&0
m1: defm "kempston"&0
m2: defm "amx"&0&0

.table
   defw m0,m1,m2
