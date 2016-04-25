; void in_MouseAMX(uchar *buttons, uint *xcoord, uint *ycoord)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC in_MouseAMX
PUBLIC _in_MouseAMX
EXTERN INMouseAMX

.in_MouseAMX
._in_MouseAMX

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
   
   push hl
   push hl
   push hl
   ex de,hl
   jp (hl)
