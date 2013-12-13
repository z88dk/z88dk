
XLIB __malloc_block_allocate

__malloc_block_allocate:

   ; Allocates bytes into indicated block.
   ; Assumes there is sufficient space to do so.
   ;
   ; enter : hl = & block
   ;         bc = request size (includes header)
   ;
   ; exit  : carry reset
   ;         hl = & allocated memory (ie past header)
   ;
   ; uses  : af, de, hl
   
   push hl                     ; save block
   
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->committed
   
   pop hl                      ; hl = & block
   
   ld a,d
   or e
   jr z, committed_zero        ; don't need to adjust any pointers
   
   ex de,hl
   add hl,de
   ex de,hl
   
   ; bc = request size
   ; hl = & block
   ; de = & new_block
   
   ; adjust block pointers
   
   push bc                     ; save request size
   
   ld c,(hl)
   ld (hl),e
   inc hl
   ld b,(hl)                   ; bc = block->next
   ld (hl),d                   ; block->next = new_block
   dec hl
   ex de,hl
   
   ; bc = block->next
   ; hl = & new_block
   ; de = & block
   ; stack = request size
   
   ld a,b
   or c
   jr z, skip_previous_ptr

   inc bc
   inc bc
   inc bc
   inc bc                      ; bc = & block->next->prev
   
   ld a,l
   ld (bc),a
   inc bc
   ld a,h
   ld (bc),a                   ; block->next->prev = & new_block
   dec bc
   
skip_previous_ptr:

   ; bc = block->next
   ; hl = & new_block
   ; de = & block
   ; stack = request size

   ld (hl),c
   inc hl
   ld (hl),b                   ; new_block->next = block->next
   inc hl
   
   pop bc                      ; bc = request size
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; new_block->committed = size
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; new_block->prev = block
   inc hl                      ; hl = & allocated memory
   
   ret                         ; carry reset here

committed_zero:

   ; hl = & block
   ; bc = request size
   ; de = 0
   
   ; this is a block without any committed bytes
   
   inc hl
   inc hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; block->committed = size
   inc hl
   
   inc hl
   inc hl                      ; hl = & allocated memory
   
   ret                         ; carry reset here
