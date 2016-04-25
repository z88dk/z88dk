; void in_MouseSim(struct in_UDM *u, uchar *buttons, uint *xcoord, uint *ycoord)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC in_MouseSim
PUBLIC _in_MouseSim
EXTERN INMouseSim

.in_MouseSim
._in_MouseSim

   ld hl,8
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   call INMouseSim
   
   pop de
   pop hl
   ld (hl),a
   inc hl
   xor a
   ld (hl),a
   pop hl
   ld (hl),b
   inc hl
   ld (hl),a
   pop hl
   ld (hl),c

   push hl
   push hl
   push hl
   ex de,hl
   jp (hl)
