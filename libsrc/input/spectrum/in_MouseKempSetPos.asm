; void in_MouseKempSetPos(uint xcoord, uint ycoord)
; 09.2005 aralbrec

XLIB in_MouseKempSetPos
LIB INMouseKempSetPos

.in_MouseKempSetPos
   ld hl,2
   add hl,sp
   ld b,(hl)
   inc hl
   ld a,(hl)
   or a
   jr z, cont1
   ld b,191
.cont1
   inc hl
   ld c,(hl)
   inc hl
   ld a,(hl)
   or a
   jp z, INMouseKempSetPos
   ld c,255
   jp INMouseKempSetPos
