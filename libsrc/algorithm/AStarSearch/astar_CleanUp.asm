; void __FASTCALL__ astar_Cleanup(struct astar_path *p)
; delete paths in astar's priority queue and optional path in parameter
; 01.2007 aralbrec

SECTION code_clib
PUBLIC astar_CleanUp
PUBLIC _astar_CleanUp
EXTERN astar_DeletePath
EXTERN _astar_queueN, _astar_queue

.astar_CleanUp
._astar_CleanUp

   call astar_DeletePath     ; does nothing if hl=0

   ld hl,(_astar_queue)
   inc hl
   inc hl
   ld bc,(_astar_queueN)

.loop

   ld a,b
   or c
   jr z, done
   dec bc
   
   ld e,(hl)
   inc hl
   ld d,(hl)
   inc hl
   
   push hl
   push bc
   
   ex de,hl
   call astar_DeletePath
   
   pop bc
   pop hl
   
   jp loop
   
.done

   ld (_astar_queueN),bc
   ret
