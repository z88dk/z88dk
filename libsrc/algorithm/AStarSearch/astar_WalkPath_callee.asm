
; uint *astar_WalkPath_callee(struct astar_path *p, uint *node_arr, uint n)
; write up to N nodes from the end of the path into the end of NODE_ARR, ret ptr in array to first node
; 01.2007 aralbrec

SECTION code_clib
PUBLIC astar_WalkPath_callee
PUBLIC _astar_WalkPath_callee
PUBLIC ASMDISP_ASTAR_WALKPATH_CALLEE

.astar_WalkPath_callee
._astar_WalkPath_callee

   pop af
   pop bc
   pop hl
   pop de
   push af
   
   ; enter : bc = uint n
   ;         hl = uint []
   ;         de = astar_path *
   ; exit  : hl = ptr into uint[] where first node in sequence written
   ;         C flag set if entire path not written
   ;         
   ; uses  : af, bc, de, hl

.asmentry

   ld a,d                    ; so many tests for zero, very annoying
   or e
   ret z
   
   ld a,b
   or c
   scf
   ret z

   add hl,bc
   add hl,bc
   ex de,hl
   
.loop

   ld a,h
   or l
   jr z, done

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
   ld l,a                    ; hl = & next struct astar_path
   
   jp pe, loop
   
   ex de,hl
   
   ld a,d                    ; wrote all nodes of path if next path = 0
   or e
   ret z
   
   scf
   ret

.done

   ex de,hl
   ret

DEFC ASMDISP_ASTAR_WALKPATH_CALLEE = # asmentry - astar_WalkPath_callee
