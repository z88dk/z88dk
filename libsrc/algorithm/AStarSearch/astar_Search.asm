; struct astar_path *astar_Search(void)
; return least costly path from src_node to dst_node
; 01.2007 aralbrec

; exit : if path found, C flag set and HL = struct astar_path *
;        if not found, NC flag set and HL = 0
;        if out of mem, NC flag set and HL = current lowest cost struct astar_path *
; 
; NOTE :
;
;   There will still be paths stored in the priority queue on
;   return.  Those paths and the path returned must have their
;   memory deallocated to finish cleanup.  A call to astar_CleanUp()
;   will complete cleanup; if the path parameter to this function
;   is non-zero, the path will also be deleted.  This implementation
;   does not perform this cleanup automatically on exit in order
;   to allow search resumption.

SECTION code_clib
PUBLIC astar_Search
PUBLIC _astar_Search
PUBLIC ASMDISP_ASTAR_SEARCH_RESUME_SUCCESS, ASMDISP_ASTAR_SEARCH_RESUME_FAIL

EXTERN l_setmem, l_jpix, ADTHeapAdd, ADTHeapExtract, astar_DeletePath
EXTERN _u_malloc, _u_free

EXTERN _astar_TestAndClose, _astar_Successor
EXTERN _astar_queue, _astar_queueSize, _astar_queueN
EXTERN _astar_startNode, _astar_destNode

.astar_Search
._astar_Search
   push ix
   call astar_Search_entry
   pop  ix
   ret

.astar_Search_entry

   ; get memory for initial path containing starting point
   
   ld hl,7                   ; sizeof(struct astar_path)
   push hl
   call _u_malloc
   pop de
   ret nc                    ; alloc failed, hl = 0, NC flag
   
   ; hl = & new struct astar_path
   
   ; fill in start path

   ld de,(_astar_startNode)
   ld (hl),e
   inc hl
   ld (hl),d
   inc hl
   xor a
   call l_setmem - 9         ; clear next five bytes to zero (ref count, prefix, cost)

   ld (_astar_queueN),a      ; nothing in queue
   ld (_astar_queueN + 1),a

   ld bc,-6
   add hl,bc
   ex de,hl
   
.loop

   ; de = current path to investigate, & struct astar_Path

   ex de,hl

.resumefail

   push hl
   ld e,(hl)
   inc hl
   ld d,(hl)
   
   ; stack = & current astar_Path
   ; de = last node in current path

   ld hl,(_astar_destNode)   ; compare last node with dest node
   ld a,l
   cp e
   jp nz, pathnotfound
   ld a,h
   cp d
   jp z, foundpath           ; if equal, path found

.pathnotfound

   ; stack = & current astar_path
   ; de = last node in current path

   ex de,hl                  ; test if last node in current path was closed
   push hl                   ;   and close it if not
   ld ix,(_astar_TestAndClose)
   call l_jpix               ; astar_TestAndClose(hl=node)
   pop hl
   jp c, closepath           ; if was closed, shorter path already through here
   
   ; stack = & current astar_path
   ; hl = last node in current path

   push hl                   ; cost
   push hl                   ; node
   
   ld hl,0
   add hl,sp
   push hl
   ld e,l
   ld d,h
   inc de
   inc de
   push de
   ld ix,(_astar_Successor)
   call l_jpix               ; astar_Successor(hl=&node,de=&cost)
   pop hl
   pop hl
   jp c, closepath2          ; there are no successors!

.successorlp

   ; stack = & astar_path, cost, successor node

   ld hl,7                   ; sizeof(struct astar_path)
   push hl
   call _u_malloc
   pop de
   jp nc, abandon            ; no more memory must give up

   ; stack = & astar_path, cost, successor node
   ; hl = & new struct astar_path

   pop de                    ; de = successor node
   ld (hl),e                 ; store successor node in new path
   inc hl
   ld (hl),d
   inc hl
   ld (hl),0                 ; reference count set to 0
   inc hl
   pop de                    ; de = cost
   pop bc                    ; bc = & current astar_path
   ld (hl),c                 ; store current path into prefix of new one
   inc hl
   ld (hl),b
   inc hl
   
   ; hl = & new struct astar_path.cost
   ; bc = & current astar_path
   ; de = cost
   
   push hl
   ld hl,5
   add hl,bc
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   ; stack = & new struct astar_path.cost
   ; bc = & current astar_path
   ; hl = cost of current path
   ; de = cost
   
   add hl,de
   jp nc, noadj
   ld hl,$ffff               ; if overflow cap cost at max

.noadj

   ex de,hl
   pop hl
   ld (hl),e                 ; write total cost into new path struct
   inc hl
   ld (hl),d

   ; bc = & current astar_path
   ; hl = & new astar_path + 6b
   
   push bc
   ld de,-6
   add hl,de
   
   ; stack = & current astar_path
   ; hl = & new astar_path

   ld de,(_astar_queueN)      ; de = # paths in queue now
   ld bc,(_astar_queueSize)   ; bc = max # allowed
   ld a,e
   cp c
   jp nz, notatmax
   ld a,d
   cp b
   jr z, abandon2             ; if there's no room in the queue, must abandon search

.notatmax

   inc de
   ld (_astar_queueN),de

   ; stack = & current astar_path
   ; hl = & new astar_path
   ; de = # items in queue after this one added

   ex de,hl
   ld bc,(_astar_queue)
   ld ix,costcompare
   call ADTHeapAdd           ; add new path to priority queue

   pop hl
   push hl
   
   ; stack = & current astar_path
   ; hl = & current astar_path
   
   inc hl
   inc hl
   inc (hl)                  ; increase ref count of current path

   ; stack = & current astar_path
   
   ld hl,-1
   push hl                   ; cost
   push hl                   ; node
   
   inc hl
   add hl,sp
   push hl
   ld e,l
   ld d,h
   inc de
   inc de
   push de
   ld ix,(_astar_Successor)
   call l_jpix               ; astar_Successor(hl=&node,de=&cost)
   pop hl
   pop hl

   ; stack = & astar_path, cost, successor node

   jp nc, successorlp        ; more successors to deal with
   
   ; stack = & astar_path, cost, successor node

   pop hl                    ; clear out the stack
   pop hl
   pop hl

.getnextpath

   ld ix,costcompare
   ld de,(_astar_queue)
   ld hl,(_astar_queueN)
   call ADTHeapExtract
   jr nc, failed             ; ran out of paths!

   ld e,l
   ld d,h                    ; de = & next astar_path to investigate

   jp loop

.closepath2

   ; stack = & astar_path, cost, successor node

   pop hl
   pop hl

.closepath

   ; stack = & current astar_path

   pop hl
   call astar_DeletePath     ; walk path, deleting nodes as necessary
   jp getnextpath

.abandon2

   ; stack = & current astar_path
   ; hl = & new astar_path

   push hl
   call _u_free
   pop hl
   pop hl
   ret                       ; ret with NC to indicate failure

.abandon

   ; stack = & astar_path, cost, successor node
   
   pop hl
   pop hl
   pop hl
   ret                       ; ret with NC to indicate failure

.failed

   ld hl,0                   ; ret with NC to indicate failure
   ret

.foundpath

   ; stack = & current astar_path

   pop hl
   scf                       ; carry set to indicate success
   ret

.costcompare

   ; called by ADTHeapAdd
   ; de = &heap[child], hl=&heap[parent]
   ; return carry set if child < parent for min heap
   ; PRESERVE BC,DE,HL,IX

   push de
   push hl
   push bc
   
   ld bc,6
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   add hl,bc
   
   ex de,hl
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   add hl,bc
   
   ; de = & parent astar_path.cost + 1b
   ; hl = & child astar_path.cost + 1b
   
   ld a,(de)                 ; compare costs
   cp (hl)
   jp c, exitcompare
   jp nz, exitcompare
   dec de
   dec hl
   ld a,(de)
   cp (hl)

.exitcompare

   pop bc
   pop hl
   pop de
   ccf                       ; correct sense of carry flag for min heap
   ret

DEFC ASMDISP_ASTAR_SEARCH_RESUME_SUCCESS = # getnextpath - astar_Search
DEFC ASMDISP_ASTAR_SEARCH_RESUME_FAIL = # resumefail - astar_Search
