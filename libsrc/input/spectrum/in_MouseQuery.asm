; void *in_MouseQuery(uchar i)
; 09.2005 aralbrec

XLIB in_MouseQuery
LIB in_MouseSimInit, in_MouseSimSetPos, in_MouseSim
LIB in_MouseKempInit, in_MouseKempSetPos, in_MouseKemp
LIB in_MouseAMXInit2, in_MouseAMXSetPos, in_MouseAMX

.in_MouseQuery
   ld a,l
   cp 3
   jr c, inrange
   xor a
.inrange
   add a,a
   ld l,a
   add a,a
   add a,l
   ld l,a
   ld h,0
   ld de,table
   add hl,de
   ret

.table
   defw in_MouseSimInit, in_MouseSimSetPos, in_MouseSim
   defw in_MouseKempInit, in_MouseKempSetPos, in_MouseKemp
   defw in_MouseAMXInit2, in_MouseAMXSetPos, in_MouseAMX
