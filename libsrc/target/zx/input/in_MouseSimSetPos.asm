; void in_MouseSimSetPos(struct in_UDM *u, uint xcoord, uint ycoord)
; CALLER linkage for function pointers

SECTION code_clib
PUBLIC in_MouseSimSetPos
PUBLIC _in_MouseSimSetPos

EXTERN in_MouseSimSetPos_callee
EXTERN ASMDISP_IN_MOUSESIMSETPOS_CALLEE


.in_MouseSimSetPos
._in_MouseSimSetPos

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
