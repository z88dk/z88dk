; void __CALLEE__ in_MouseKemp_callee(uchar *buttons, uint *xcoord, uint *ycoord)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_MouseKemp_callee
PUBLIC _in_MouseKemp_callee
EXTERN INMouseKemp

.in_MouseKemp_callee
._in_MouseKemp_callee

   call INMouseKemp
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
