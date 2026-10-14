
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

PUBLIC asm_heap_realloc_unlocked_fast

EXTERN error_enomem_zc, __heap_allocate_block, asm_memmove, asm_heap_free_unlocked, l_ltu_bc_hl
EXTERN __heap_fl_anchor, __heap_fl_prepare, __heap_fl_unlink, __heap_fl_link
EXTERN __heap_fl_hole_heap, __heap_fl_hole_count

asm_heap_realloc_unlocked_fast:

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

   push hl
   call __heap_fl_prepare      ; de = heap. builds the free list once
   pop hl

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
   ;
   ; The spare tail moves with committed, so the old node has to come
   ; off the free list before the new one goes on.

   ; hl = & block_p
   ; bc = gross request size
   ; stack = void *heap

   push hl
   call __heap_fl_unlink
   pop hl

   inc hl
   inc hl

   ld (hl),c
   inc hl
   ld (hl),b                   ; block_p->committed = gross request size

   dec hl
   dec hl
   dec hl                      ; hl = & block_p

   push hl
   call __heap_fl_link
   pop hl

   ld de,6
   add hl,de                   ; hl = void *p

   pop de                      ; junk item on stack
   or a
   ret


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
   inc hl                      ; hl = void *p = void *p_old

   ex (sp),hl                  ; hl = void *heap, stack = void *p_old
   push de                     ; stack = p_old->committed, void *p_old
   push hl                     ; stack = void *heap, p_old->committed, void *p_old

   ld e,l
   ld d,h                      ; de = void *heap

   ld hl,4
   add hl,sp
   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a                      ; hl = void *p_old

   call asm_heap_free_unlocked ; de must be the heap. bc preserved.
   pop hl

   ; find the largest block in the heap

   ; hl = void *heap
   ; bc = gross request size
   ; stack = p_old->committed, void *p_old

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
   ;
   ; The first block's prev word is the free-list head, so it is not
   ; a previous header. Every other block still points at its owner.

   ; stack = void *p_old, p_old->committed

   pop bc                      ; bc = block_p->committed
   pop hl                      ; hl = void *p

   ld de,-6
   add hl,de                   ; hl = & block_p

   push hl

   ld de,(__heap_fl_anchor)
   dec de
   dec de
   dec de
   dec de                      ; de = & first block

   ld a,l
   cp e
   jr nz, alloc_fail_prev
   ld a,h
   cp d
   jr nz, alloc_fail_prev

   pop hl
   ld e,l
   ld d,h                      ; overlay the first block
   call __heap_allocate_block
   jp error_enomem_zc

alloc_fail_prev:

   pop hl                      ; hl = & block_p
   push hl

   ld de,4
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block_p->prev = & block_prev

   pop hl
   ex de,hl                    ; hl = & block_prev, de = & block_p

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
   ;
   ; The free list names every committed tail of at least 7 bytes.
   ; A non-first committed == 0 wilderness is not on that list. The
   ; hole count says when one of those can still exist. The count may
   ; stay high after malloc takes such a hole. It is never left low.

   push ix
   push bc                     ; save gross request

   ld bc,0                     ; best size
   ld ix,0                     ; best block

   ld hl,(__heap_fl_anchor)
   dec hl
   dec hl
   dec hl
   dec hl                      ; hl = & first block

   call region_best

   ld hl,(__heap_fl_anchor)
   ld e,(hl)
   inc hl
   ld d,(hl)
   dec hl                      ; de = head, hl = & head

best_walk:

   ld a,d
   or e
   jr z, best_done

   ld a,e
   cp l
   jr nz, best_node
   ld a,d
   cp h
   jr z, best_done             ; empty sentinel

best_node:

   push hl                     ; save & head
   push de                     ; save & node

   ld hl,4
   add hl,de
   ld e,(hl)
   inc hl
   ld d,(hl)
   ex de,hl                    ; hl = owner

   call region_best

   pop hl                      ; hl = & node
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = node->next
   pop hl                      ; hl = & head
   jr best_walk

best_done:

   call hole_cache_miss        ; carry set if the list may not be complete
   jr c, full_scan

   pop hl                      ; hl = gross request
   push hl

   call l_ltu_bc_hl            ; carry if best size < gross
   jr c, best_short

   pop bc                      ; bc = gross request
   push ix
   pop de                      ; de = & block_largest
   pop ix
   or a
   ret

best_short:

   ; A tail shorter than 7 is absent from the list. It can satisfy
   ; only a gross request below 7.

   pop hl                      ; hl = gross request
   push hl

   ld a,h
   or a
   jr nz, best_fail

   ld a,l
   cp 7
   jr c, full_scan

best_fail:

   pop bc
   pop ix
   scf
   ret

full_scan:

   ; stack = gross request, saved ix

   xor a
   ld (__heap_fl_hole_count),a

   ld hl,(__heap_fl_anchor)
   ld a,l
   sub 10
   ld e,a
   ld a,h
   sbc a,0
   ld d,a
   ld (__heap_fl_hole_heap),de

   ld bc,0
   ld ix,0

   ld hl,(__heap_fl_anchor)
   dec hl
   dec hl
   dec hl
   dec hl                      ; hl = & first block

scan_loop:

   ; hl = & block
   ; bc = best size
   ; ix = & best block

   ld e,(hl)
   inc hl
   ld d,(hl)
   dec hl                      ; de = block->next

   ld a,d
   or e
   jr z, scan_end

   push de                     ; save & next
   push hl

   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->committed
   pop hl                      ; hl = & block

   push bc
   ld c,e
   ld b,d                      ; bc = committed
   call note_hole
   pop bc                      ; bc = best size

   call region_best
   pop hl                      ; hl = & next block
   jr scan_loop

scan_end:

   pop hl                      ; hl = gross request
   push ix
   pop de                      ; de = & block_largest

   call l_ltu_bc_hl            ; carry if best size < gross
   ld c,l
   ld b,h                      ; bc = gross request
   jr c, scan_fail

   pop ix
   or a
   ret

scan_fail:

   pop ix
   scf
   ret


region_best:

   ; Consider one block's free bytes.
   ;
   ; enter : hl = & block
   ;         bc = best size so far
   ;         ix = & best block so far
   ;
   ; exit  : bc = best size
   ;         ix = & best block
   ;         hl unchanged? no, hl is consumed
   ;
   ; uses  : af, de, hl

   push bc                     ; best size
   push hl                     ; & block

   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block->next
   ld a,d
   or e
   jr z, region_none

   inc hl
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->committed

   pop hl                      ; hl = & block
   push hl

   add hl,bc                   ; hl = allocation address
   ex de,hl                    ; de = allocation address, hl = block->next
   or a
   sbc hl,de                   ; hl = free bytes

   pop de                      ; de = & block
   pop bc                      ; bc = best size

   push de
   call l_ltu_bc_hl            ; carry if best < free
   jr c, region_bigger

   pop af
   ret

region_bigger:

   pop ix                      ; ix = & block
   ld c,l
   ld b,h                      ; bc = free bytes
   ret

region_none:

   pop hl
   pop bc
   ret


hole_cache_miss:

   ; carry set when largest-fit must walk the address chain
   ;
   ; preserves bc, de, hl, ix

   push hl
   push de
   push bc

   ld de,(__heap_fl_hole_heap)
   ld hl,(__heap_fl_anchor)
   ld a,l
   sub 10
   ld c,a
   ld a,h
   sbc a,0
   cp d
   jr nz, hole_miss
   ld a,c
   cp e
   jr nz, hole_miss

   ld a,(__heap_fl_hole_count)
   or a
   jr nz, hole_miss

   pop bc
   pop de
   pop hl
   or a
   ret

hole_miss:

   pop bc
   pop de
   pop hl
   scf
   ret


note_hole:

   ; Count a non-first committed == 0 block.
   ;
   ; enter : hl = & block
   ;         bc = committed
   ;
   ; exit  : hl, bc, de unchanged
   ;
   ; uses  : af

   ld a,b
   or c
   ret nz

   push de
   push hl

   ld de,(__heap_fl_anchor)
   dec de
   dec de
   dec de
   dec de                      ; de = & first block

   ld a,l
   cp e
   jr nz, note_count
   ld a,h
   cp d
   jr z, note_out

note_count:

   ld a,(__heap_fl_hole_count)
   inc a
   jr z, note_out              ; saturated at 255
   ld (__heap_fl_hole_count),a

note_out:

   pop hl
   pop de
   ret
