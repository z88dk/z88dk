
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_realloc_unlocked(void *heap, void *p, size_t size)
;
; Resize the memory block p to size bytes.  If this cannot
; be done in-place, a new memory block is allocated and the
; data at address p is copied to the new block.
;
; If p == 0, an effective malloc is performed, except a
; successful allocation occurs from the largest block available
; in the heap to allow for further quick growth via realloc.
;
; If p != 0 and size == 0, the block is reduced to zero size
; but is not freed.  You must call free to free blocks.
;
; If successful, returns ptr to the reallocated memory block,
; which may be p if the block was resized in place.
;
; If unsuccessful, returns 0 with carry set.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_realloc_unlocked

EXTERN error_enomem_zc, __heap_allocate_block, asm_memmove, asm_heap_free_unlocked, l_ltu_bc_hl

asm_heap_realloc_unlocked:

   ; Realloc without locking
   ;
   ; enter : de = void *heap
   ;         hl = void *p (existing pointer to memory)
   ;         bc = uint size (realloc size)
   ;
   ; exit  : success
   ;
   ;            hl = void *p_new
   ;            carry reset
   ;
   ;         fail on insufficient memory
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save void *heap
   push hl                     ; save void *p
   
   ld hl,6                     ; sizeof(heap header)
   add hl,bc                   ; add space for header to request size
   jp c, error_enomem_zc - 2
   
   ld c,l
   ld b,h                      ; bc = gross request size
   
   pop hl                      ; hl = void *p
   
   ld a,h
   or l
   jr z, allocating            ; if p == 0, we are allocating

resize:

   ; hl = void *p
   ; bc = gross request size
   ; stack = void *heap
   
   ld de,-5
   add hl,de                   ; hl = & block_p->next + 1b

   ld d,(hl)
   dec hl                      ; hl = & block_p
   ld e,(hl)                   ; de = block_p->next = & block_next

   ex de,hl
   
   or a
   sbc hl,de
   sbc hl,bc                   ; hl = block_next - block_p - gross_request

   ex de,hl
   jr c, resize_fail           ; if cannot resize in place

   ; resize will be successful

   ; hl = & block_p
   ; bc = gross request size
   ; stack = void *heap

   inc hl
   inc hl
   
   ld (hl),c
   inc hl
   ld (hl),b                   ; block_p->committed = gross request size
   inc hl
   
   inc hl
   inc hl                      ; hl = void *p
   
   pop de                      ; junk item on stack
   ret                         ; carry is reset


allocating:

   ; p == 0 so we are allocating not resizing

   pop hl
   
   ; hl = void *heap
   ; bc = gross request size

   call largest_fit
   jp c, error_enomem_zc
   
   ; de = & block_largest
   ; bc = gross request size

   ld l,e
   ld h,d
   
   inc hl
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = block->committed
   
   add hl,de
   ex de,hl
   
   ; de = & block_new
   ; hl = & block
   ; bc = gross request size
   
   jp __heap_allocate_block


resize_fail:

   ; first free the block then try to allocate a new one

   ; hl = & block_p
   ; bc = gross request size
   ; stack = void *heap

   inc hl
   inc hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = p->committed = p_old->committed
   inc hl
   
   inc hl
   inc hl                     ; hl = void *p = void *p_old
   
   pop af
   push hl
   push de
   push af

   ; hl = void *p_old
   ; bc = gross request size
   ; stack = void *p_old, p_old->committed, void *heap

   call asm_heap_free_unlocked
   pop hl

   ; find the largest block in the heap
   
   ; hl = void *heap
   ; bc = gross request size
   ; stack = void *p_old, p_old->committed
   
   call largest_fit
   jr c, alloc_fail

   ; allocate memory out of the largest block

   ; de = & block_largest = & block
   ; bc = gross request size
   ; stack = void *p_old, p_old->committed

   ld l,e
   ld h,d
   
   inc hl
   inc hl
   
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = block->committed
   
   add hl,de
   ex de,hl
   
   ; de = & block_new
   ; hl = & block
   ; bc = gross request size
   ; stack = void *p_old, p_old->committed
   
   call __heap_allocate_block
   ex de,hl

   ; copy data from old block to new block
   
   ; de = void *p_new
   ; stack = void *p_old, p_old->committed
   
   pop bc
   
   ld hl,-6                    ; sizeof(heap header)
   add hl,bc
   
   ld c,l
   ld b,h                      ; bc = num bytes in p
   
   pop hl                      ; hl = void *p_old
   jp asm_memmove


alloc_fail:

   ; failed to find a large enough block
   ; must restore old block to heap
   
   ; stack = void *p_old, p_old->committed

   pop bc                      ; bc = block_p->committed
   pop hl                      ; hl = void *p
   
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = block_p->prev = & block_prev

   dec hl
   dec hl
   dec hl
   dec hl                      ; hl = & block_p
   
   ex de,hl
   
   ; bc = block_p->committed = gross request size
   ; de = & block_p = & block_new
   ; hl = & block_prev = & block
   
   ld a,h
   or l
   jr nz, prev_present
   
   ; block_p is the first block in the heap
   
   ld l,e
   ld h,d

prev_present:

   call __heap_allocate_block  ; restore block to the heap
   jp error_enomem_zc   


largest_fit:

   ; enter : bc = gross request size
   ;         hl = void *heap
   ;
   ; exit  : de = & block_largest
   ;         bc = gross request size
   ;
   ;         carry set if no block large enough for request

   ld de,6                     ; sizeof(mutex)
   add hl,de

   push bc                     ; save gross request size
   
   ld bc,0
   push bc

   ex de,hl
   push de
   
block_loop:
   
   ; bc = largest block size
   ; de = & block to examine
   ; stack = gross request size, & block_largest, junk

   pop af                      ; remove junk from stack
   push de                     ; save & block

   ex de,hl
   
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->next = & block_next
   
   ld a,d
   or e
   jr z, end_loop              ; if end of heap reached

   inc hl
   
   push bc                     ; save largest block size
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->committed

   dec hl
   dec hl
   dec hl                      ; hl = & block
   
   ex de,hl
   
   ; bc = block->committed
   ; de = & block
   ; hl = & block_next
   ; stack = gross request size, & block_largest, & block, largest block size
   
   push hl                     ; save & block_next
   
   sbc hl,de
   sbc hl,bc                   ; hl = free bytes in this block
   
   pop de                      ; de = & block_next
   pop bc                      ; bc = largest block size

   call l_ltu_bc_hl
   jr nc, block_loop           ; if bc >= hl

block_bigger:

   ; hl = new largest block size
   ; de = & block_next
   ; stack = gross request size, & block_largest, & block

   ld c,l
   ld b,h                      ; bc = new largest block size
   
   pop hl
   ex (sp),hl                  ; replace & block_largest with & block
   push hl
   
   jr block_loop

end_loop:

   ; biggest block found
   
   ; bc = largest block size
   ; stack = gross request size, & block_largest, junk

   pop de
   pop de                      ; de = & block_largest

   ld l,c
   ld h,b                      ; hl = largest block size
   
   pop bc                      ; bc = gross request size

   sbc hl,bc
   ret                         ; carry set if block not large enough
