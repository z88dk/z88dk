
SECTION code_clib
SECTION code_alloc_malloc

PUBLIC __heap_allocate_block

EXTERN __heap_fl_link, __heap_fl_unlink

__heap_allocate_block:

   ; Create a new block inside the existing block at the given address.
   ; Assumes there is sufficient space to do so.
   ;
   ; enter : bc = gross request size
   ;         hl = & block
   ;         de = & block_new
   ;
   ; exit  : hl = void *p (address of byte following header in block_new)
   ;         bc = gross request size
   ;         carry reset
   ;
   ; uses  : af, de, hl

   ; A non-first committed == 0 hole is not removed from the hole
   ; count here. The count may stay high. Largest-fit treats that as
   ; a miss and the following scan recounts. The count must not go low.
   call __heap_fl_unlink       ; drop the old tail, if it was listed

   push de                     ; save & block_new
   push hl                     ; save & block

   ; if block_new == block, we are overlaying
   
   ld a,e
   cp l
   jr nz, insert_block
   
   ld a,d
   cp h
   jr z, overlay_block

insert_block:

   ; insert block_new into block's free space
   
   push bc                     ; save gross request size
   
   ld c,(hl)
   ld (hl),e
   inc hl
   ld b,(hl)                   ; bc = block->next = & block_next
   ld (hl),d                   ; block->next = & block_new
   dec hl
   
   ex de,hl
   
   ; bc = & block_next
   ; de = & block
   ; hl = & block_new
   ; stack = gross request size
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; block_new->next = & block_next
   dec hl
   
   ld a,(bc)
   inc bc
   
   or a
   jr nz, block_next_present
   
   ld a,(bc)
   
   or a
   jr z, block_next_absent

block_next_present:

   ; there is a block_next that follows block
   
   inc bc
   inc bc
   inc bc                      ; bc = & block_next->prev
   
   ld a,l
   ld (bc),a
   inc bc
   ld a,h
   ld (bc),a                   ; block_next->prev = & block_new

block_next_absent:

   ; hl = & block_new
   ; de = & block
   ; stack = gross request size
   
   inc hl
   inc hl
   pop bc
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; block_new->committed = gross request size
   inc hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; block_new->prev = & block
   
   jp alloc_epilogue

overlay_block:

   ; allocate on top of existing block
   
   ; hl = & block
   ; bc = gross request size
   ; carry reset
   
   inc hl
   inc hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; block->committed = gross request size
   inc hl
   
   inc hl
   inc hl                      ; hl = & allocated memory in block
   
   jp alloc_epilogue

alloc_epilogue:

   ; stack = & block_new, & block
   ; bc    = gross request size

   pop hl                      ; hl = & block
   pop de                      ; de = & block_new

   push bc
   push de

   call __heap_fl_link         ; remainder, or the alignment gap

   pop de
   pop bc

   ld a,l
   cp e
   jr nz, alloc_link_new

   ld a,h
   cp d
   jr z, alloc_user

alloc_link_new:

   push bc
   push de

   ld l,e
   ld h,d                      ; hl = & block_new

   call __heap_fl_link

   pop de
   pop bc

alloc_user:

   ld hl,6
   add hl,de                   ; hl = & allocated memory

   or a
   ret
