
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void heap_free_unlocked(void *heap, void *p)
;
; Deallocate memory previously allocated at p from the heap.
;
; If p == 0, function returns without performing an action.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_free_unlocked_fast

EXTERN __heap_fl_anchor, __heap_fl_prepare, __heap_fl_link, __heap_fl_unlink

asm_heap_free_unlocked_fast:

   ; Return the memory block to the heap for reuse without locking
   ;
   ; enter : hl = void *p
   ;         de = void *heap
   ;
   ; exit  : carry reset
   ;
   ; uses  : af, de, hl

   ld a,h
   or l
   ret z                       ; if p == 0

   push bc
   push hl                     ; save void *p

   call __heap_fl_prepare

   pop hl                      ; hl = void *p

   ld de,-6
   add hl,de                   ; hl = & block

   push hl
   call __heap_fl_unlink       ; drop this block's tail before it moves
   pop hl

   ld de,(__heap_fl_anchor)
   dec de
   dec de
   dec de
   dec de                      ; de = & first block

   ld a,l
   cp e
   jr nz, free_unlink

   ld a,h
   cp d
   jr nz, free_unlink

   inc hl
   inc hl                      ; hl = & block->committed

   xor a
   ld (hl),a
   inc hl
   ld (hl),a                   ; committed = 0. The hole stays off the
                               ; free list so the old payload is intact.
                               ; malloc tests this first block directly.

   pop bc
   or a
   ret

free_unlink:

   ; hl = & block
   ; splice it out of the address chain, then list the previous block's
   ; grown tail. A previous block with committed == 0 is not listed.

   push hl

   ld de,4
   add hl,de

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->prev

   pop hl                      ; hl = & block

   push hl
   push de

   ld l,e
   ld h,d                      ; hl = & block_prev

   call __heap_fl_unlink       ; old tail, before next changes

   pop de                      ; de = & block_prev
   pop hl                      ; hl = & block

   push de

   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->next
   dec hl

   ex de,hl                    ; hl = & block_prev, de = & block

   ld (hl),c
   inc hl
   ld (hl),b                   ; block_prev->next = block->next

   ld a,b
   or c
   jr z, free_no_next

   ld l,c
   ld h,b
   ld a,(hl)
   inc hl
   or (hl)
   jr z, free_no_next          ; terminator has no prev word

   ld hl,4
   add hl,bc                   ; hl = & block_next->prev

   pop de
   push de

   ld (hl),e
   inc hl
   ld (hl),d                   ; block_next->prev = & block_prev

free_no_next:

   pop hl                      ; hl = & block_prev

   call __heap_fl_link

   pop bc
   or a
   ret
