; void in_MouseAMXSetPos(uint xcoord, uint ycoord)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC in_MouseAMXSetPos
PUBLIC _in_MouseAMXSetPos

EXTERN centry_in_MouseAMXSetPos

.in_MouseAMXSetPos
._in_MouseAMXSetPos

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp centry_in_MouseAMXSetPos
