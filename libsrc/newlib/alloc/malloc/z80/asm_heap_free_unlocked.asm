
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

PUBLIC asm_heap_free_unlocked

EXTERN l_setmem_hl

asm_heap_free_unlocked:

   ; Return the memory block to the heap for reuse without locking
   ;
   ; enter : hl = void *p
   ;         de = void *heap (unused)
   ;
   ; exit  : carry reset
   ;
   ; uses  : af, de, hl

   ld a,h
   or l
   ret z                       ; if p == 0
   
   dec hl                      ; step into block header
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = block->prev = & block_prev
   
   dec hl
   dec hl                      ; hl = & block->committed

   ld a,d
   or e
   jp z, l_setmem_hl - 4       ; if there is no previous block, set block->committed = 0

remove_block:

   dec hl
   dec hl

   ; hl = & block
   ; de = & block_prev

   ldi
   inc bc                      ; undo changes to bc

   ld a,(hl)
   ld (de),a                   ; block_prev->next = block->next
   
   dec de                      ; de = & block_prev
   dec hl                      ; hl = & block
   
   ld l,(hl)
   ld h,a                      ; hl = block->next = & block_next

   ld a,(hl)
   inc hl
   or (hl)
   ret z                       ; if there is no block_next

   inc hl
   inc hl
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; block_next->prev = & block_prev
   
   ret
