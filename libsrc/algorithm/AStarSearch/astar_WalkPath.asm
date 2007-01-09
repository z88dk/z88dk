; CALLER linkage for function pointers

XLIB astar_WalkPath
LIB astar_WalkPath_callee
XREF ASMDISP_ASTAR_WALKPATH_CALLEE

.astar_WalkPath

   pop af
   pop bc
   pop hl
   pop de
   push de
   push hl
   push bc
   push af
   
   jp astar_WalkPath_callee + ASMDISP_ASTAR_WALKPATH_CALLEE

