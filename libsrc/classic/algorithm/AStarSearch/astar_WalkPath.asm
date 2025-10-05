; CALLER linkage for function pointers

SECTION code_clib
PUBLIC astar_WalkPath
PUBLIC _astar_WalkPath
EXTERN asm_astar_WalkPath

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
   
   jp asm_astar_WalkPath

