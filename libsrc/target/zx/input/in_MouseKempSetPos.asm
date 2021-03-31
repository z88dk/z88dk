; void in_MouseKempSetPos(uint xcoord, uint ycoord)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_MouseKempSetPos
PUBLIC _in_MouseKempSetPos

EXTERN centry_in_MouseKempSetPos

.in_MouseKempSetPos
._in_MouseKempSetPos

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp centry_in_MouseKempSetPos
