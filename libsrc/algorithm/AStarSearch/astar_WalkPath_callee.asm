
; uint *astar_WalkPath_callee(struct astar_path *p, uint *node_arr, uint n)
; write up to N nodes from the end of the path into the end of NODE_ARR, ret ptr in array to first node
; 01.2007 aralbrec

XLIB astar_WalkPath_callee
XDEF ASMDISP_ASTAR_WALKPATH_CALLEE

.astar_WalkPath_callee

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   ; enter : bc = uint n
   ;         hl = uint []
   ;         de = astar_path *
   ; uses  : af, bc, de, hl

.asmentry

   ld a,b
   or c
   ret z

   add hl,bc
   add hl,bc
   ex de,hl
   
.loop

   dec de
   inc hl
   ldd
   ld a,(hl)
   ld (de),a
   
   inc hl
   inc hl
   inc hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   jp pe, loop
   
   ex de,hl
   ret

DEFC ASMDISP_ASTAR_WALKPATH_CALLEE = asmentry - astar_WalkPath_callee
