; void in_MouseAMXSetPos(uint xcoord, uint ycoord)
; 09.2005 aralbrec

XLIB in_MouseAMXSetPos
LIB INMouseAMXSetPos

.in_MouseAMXSetPos
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
   jp z, INMouseAMXSetPos
   ld c,255
   jp INMouseAMXSetPos
