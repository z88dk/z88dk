; void in_MouseKempSetPos(uint xcoord, uint ycoord)
; 09.2005 aralbrec

SECTION code_clib
PUBLIC in_MouseKempSetPos
PUBLIC _in_MouseKempSetPos

EXTERN in_MouseKempSetPos_callee
EXTERN CDISP_IN_MOUSEKEMPSETPOS_CALLEE

.in_MouseKempSetPos
._in_MouseKempSetPos

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp in_MouseKempSetPos_callee + CDISP_IN_MOUSEKEMPSETPOS_CALLEE
