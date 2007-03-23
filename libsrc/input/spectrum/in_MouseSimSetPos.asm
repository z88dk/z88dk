; void in_MouseSimSetPos(struct in_UDM *u, uint xcoord, uint ycoord)
; CALLER linkage for function pointers

XLIB in_MouseSimSetPos

LIB in_MouseSimSetPos_callee
XREF ASMDISP_IN_MOUSESIMSETPOS_CALLEE


.in_MouseSimSetPos

   pop af
   pop bc
   pop de
   pop hl
   push hl
   push de
   push bc
   push af
   
   ld b,c
   ld c,e
   jp in_MouseSimSetPos_callee + ASMDISP_IN_MOUSESIMSETPOS_CALLEE
