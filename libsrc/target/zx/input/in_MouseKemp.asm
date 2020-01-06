; void in_MouseKemp(uchar *buttons, uint *xcoord, uint *ycoord)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC in_MouseKemp
PUBLIC _in_MouseKemp
EXTERN INMouseKemp

.in_MouseKemp
._in_MouseKemp

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
   
   push hl
   push hl
   push hl
   ex de,hl
   jp (hl)
