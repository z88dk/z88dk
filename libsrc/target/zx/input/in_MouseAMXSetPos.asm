; void in_MouseAMXSetPos(uint xcoord, uint ycoord)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC in_MouseAMXSetPos
PUBLIC _in_MouseAMXSetPos

EXTERN in_MouseAMXSetPos_callee
EXTERN CDISP_IN_MOUSEAMXSETPOS_CALLEE

.in_MouseAMXSetPos
._in_MouseAMXSetPos

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp in_MouseAMXSetPos_callee + CDISP_IN_MOUSEAMXSETPOS_CALLEE
