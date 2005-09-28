; void in_MouseKemp(uchar *buttons, uint *xcoord, uint *ycoord)
; 09.2005 aralbrec

XLIB in_MouseKemp
LIB INMouseKemp

.in_MouseKemp
   call INMouseKemp
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
