
XLIB __malloc_block_allocate_fixed
XDEF __0_malloc_block_allocate_fixed, __1_malloc_block_allocate_fixed

__malloc_block_allocate_fixed:

   ; enter : bc = request size
   ;         hl = & block
   ;         de = & block_new
   ;
   ; exit  : hl = void *p (address of first allocated bytein block_new)
   ;         carry reset
   ;
   ; uses  : af, de, hl
   
   ; if block_p == block, we are overlaying

   ld a,e
   cp l
   jp nz, __0_malloc_block_allocate_fixed

   ld a,d
   cp h
   jr z, __1_malloc_block_allocate_fixed

__0_malloc_block_allocate_fixed:

   ; bc = request size
   ; hl = & block
   ; de = & new_block
   
   ; insert new_block into block's space
   
   push bc                     ; save request size
   
   ld c,(hl)
   ld (hl),e
   inc hl
   ld b,(hl)                   ; bc = block->next = & block_next
   ld (hl),d                   ; block->next = new_block
   dec hl
   ex de,hl
   
   ; bc = & block_next
   ; hl = & new_block
   ; de = & block
   ; stack = request size
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; new_block->next = & block_next
   dec hl
   
   ld a,(bc)                   ; check if block_next is a region terminator
   inc bc
   
   or a
   jr nz, do_previous_ptr

   ld a,(bc)
   or a
   jr z, skip_previous_ptr

do_previous_ptr:

   inc bc
   inc bc
   inc bc                      ; bc = & block_next->prev
   
   ld a,l
   ld (bc),a
   inc bc
   ld a,h
   ld (bc),a                   ; block_next->prev = & new_block
   
skip_previous_ptr:

   ; hl = & new_block
   ; de = & block
   ; stack = request size

   inc hl
   inc hl
   
   pop bc                      ; bc = request size
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; new_block->committed = request size
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; new_block->prev = & block
   
   inc hl                      ; hl = & allocated memory
   ret                         ; carry reset here

__1_malloc_block_allocate_fixed:

   ; hl = & block
   ; bc = request size
   ; no change to z flag
   
   ; this is a block without any committed bytes
   ; allocate on top of existing block
      
   inc hl
   inc hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; block->committed = size
   inc hl
   
   inc hl
   inc hl                      ; hl = & allocated memory
   
   ret                         ; carry reset here
