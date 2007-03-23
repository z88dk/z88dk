; void in_MouseKempSetPos(uint xcoord, uint ycoord)
; 09.2005 aralbrec

XLIB in_MouseKempSetPos

LIB in_MouseKempSetPos_callee
XREF CDISP_IN_MOUSEKEMPSETPOS_CALLEE

.in_MouseKempSetPos

   pop de
   pop bc
   pop hl
   push hl
   push bc
   push de
   
   jp in_MouseKempSetPos_callee + CDISP_IN_MOUSEKEMPSETPOS_CALLEE
