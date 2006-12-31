
XLIB isgraph
LIB isprint

.isgraph

   ld a,l
   ld hl,0
   cp 32
   ret z
   inc l
   jp isprint+4
