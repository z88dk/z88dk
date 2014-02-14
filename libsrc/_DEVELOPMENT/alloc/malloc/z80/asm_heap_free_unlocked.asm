
XLIB asm_heap_free_unlocked

asm_heap_free_unlocked:

   ; Return the memory block to the heap for reuse without locking
   ;
   ; enter : hl = void *p
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
   dec hl                      ; hl = & block->committed + 1b

   ld a,d
   or e
   jr z, first_block           ; if there is no previous block

remove_block:

   dec hl
   dec hl
   dec hl

   ; hl = & block
   ; de = & block_prev

   ldi
   inc bc                      ; undo changes to bc

   ld a,(hl)
   ld (de),a                   ; block_prev->next = block->next
   dec de                      ; de = & block_prev

   dec hl
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

first_block:

   ; this is the first block in the heap

   ; hl = & block->committed + 1b

   xor a
   ld (hl),a
   dec hl
   ld (hl),a                   ; block->committed = 0

   ret
