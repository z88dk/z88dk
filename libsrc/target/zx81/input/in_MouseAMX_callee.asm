; void __CALLEE__ in_MouseAMX_callee(uchar *buttons, uint *xcoord, uint *ycoord)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_MouseAMX_callee
PUBLIC _in_MouseAMX_callee
EXTERN INMouseAMX

.in_MouseAMX_callee
._in_MouseAMX_callee

   call INMouseAMX
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
   ex de,hl
   jp (hl)
