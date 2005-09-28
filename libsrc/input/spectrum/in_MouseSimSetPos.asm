; void in_MouseSimSetPos(struct in_UDM *u, uint xcoord, uint ycoord)
; 09.2005 aralbrec

XLIB in_MouseSimSetPos
LIB INMouseSimSetPos

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
   jr z, cont2
   ld c,255
.cont2
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   jp INMouseSimSetPos
