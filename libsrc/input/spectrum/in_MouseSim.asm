; void in_MouseSim(struct in_UDM *u, uchar *buttons, uint *xcoord, uint *ycoord)
; 09.2005 aralbrec

XLIB in_MouseSim
LIB INMouseSim

.in_MouseSim
   ld hl,8
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   call INMouseSim
   ld hl,2
   add hl,sp
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld (de),a
   xor a
   inc de
   ld (de),a
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   ld a,b
   ld (de),a
   xor a
   inc de
   ld (de),a
   ld e,(hl)
   inc hl
   ld d,(hl)
   ld a,c
   ld (de),a
   ret
