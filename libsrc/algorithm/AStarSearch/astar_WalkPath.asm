; CALLER linkage for function pointers

SECTION code_clib
PUBLIC astar_WalkPath
PUBLIC _astar_WalkPath
EXTERN astar_WalkPath_callee
EXTERN ASMDISP_ASTAR_WALKPATH_CALLEE

.astar_WalkPath
._astar_WalkPath

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp astar_WalkPath_callee + ASMDISP_ASTAR_WALKPATH_CALLEE

