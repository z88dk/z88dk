XLIB __malloc_block_alloc

__malloc_block_alloc:

   ; Allocates bytes into indicated block.
   ; Assumes there is sufficient space to do so.
   ;
   ; enter : hl = & block
   ;         bc = request size (includes header)
   ;
   ; exit  : carry reset
   ;         hl = & allocated memory block
   ;
   ; uses  : af, de, hl
   
   push hl                     ; save block
   
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->committed
   
   pop hl                      ; hl = & block
   
   ex de,hl
   add hl,de
   ex de,hl
   
   ; bc = request size
   ; hl = & block
   ; de = & new_block
   ; carry reset
   
   ; ORDER THAT THESE POINTERS ARE UPDATED IS
   ; IMPORTANT FOR CASE BLOCK->COMMITTED = 0 !!
   
   ld a,(hl)                   ; block->next = & new_block
   ld (hl),e                   ; new_block->next = old block->next
   ld (de),a
   
   inc hl
   ld a,(hl)
   ld (hl),d
   inc de
   ld (de),a
   inc de
   
   ; de = & new_block->committed
   ; bc = request size
   
   ex de,hl
   ld (hl),c
   inc hl
   ld (hl),b
   inc hl                      ; hl = & allocated memory block
   
   ; carry is reset here
   
   ret
