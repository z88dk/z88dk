
XLIB __malloc_block_free
XDEF __0_malloc_block_free

__malloc_block_free:

   ; Deallocate the block and return it to the heap for reuse.
   ;
   ; enter : hl = & block
   ;
   ; exit  : none
   ;
   ; uses  : af, bc, de, hl

   ld de,6
   add hl,de                   ; hl = void *p

__0_malloc_block_free:

   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = block_p->prev
   dec hl                      ; hl = & block_p->committed + 1b

   ld a,d
   or e
   jr z, first_block           ; if there is no previous block
   
   dec hl
   dec hl
   dec hl                      ; hl = & block_p
   
   ld c,(hl)
   ldi
   ld a,(hl)
   ld (de),a                   ; block_prev->next = block_p->next
   
   dec de                      ; de = & block_prev
   inc c
   ld l,c
   ld h,a                      ; hl = block_p->next
   
   or c
   ret z                       ; if block_p->next == 0
   
   ld bc,4
   add hl,bc                   ; hl = & block_next->prev

   ld (hl),e
   inc hl
   ld (hl),d                   ; block_next->prev = & block_prev

   ret

first_block:

   ; there is no previous block so all we have to do
   ; is set committed to zero to free this block
   
   xor a
   ld (hl),a
   dec hl
   ld (hl),a
   
   ret
