; void __CALLEE__ in_MouseSim_callee(struct in_UDM *u, uchar *buttons, uint *xcoord, uint *ycoord)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_MouseSim_callee
PUBLIC _in_MouseSim_callee
EXTERN INMouseSim

.in_MouseSim_callee
._in_MouseSim_callee

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
   pop hl
   ex de,hl
   jp (hl)
