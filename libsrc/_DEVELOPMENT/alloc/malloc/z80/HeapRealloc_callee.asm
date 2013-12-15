
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *HeapRealloc(void *heap, void *p, size_t size)
;
; Resize the memory block p to size bytes.  If this cannot
; be done in-place, a new memory block is allocated and the
; data at address p is copied to the new block.
;
; If p == 0, an effective malloc is performed, except a
; successful allocation returns the largest block available
; in the heap to allow for further quick growth via realloc().
;
; If p != 0 and size == 0, the block is reduced to zero size
; but is not freed.  You must call free() to free blocks.
;
; If successful, returns ptr to the reallocated memory block,
; which may be p if the block was resized in place.
;
; If unsuccessful, returns 0.
;
; ===============================================================

XLIB HeapRealloc_callee
XDEF asm_HeapRealloc

LIB error_enomem_zc, asm_memmove, __0_malloc_block_free
LIB __malloc_largest_fit, __malloc_block_allocate, malloc_block_allocate_fixed

HeapRealloc_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

asm_HeapRealloc:

   ; enter : hl = void *heap (holds address of a region)
   ;         de = void *p
   ;         bc = uint size (realloc size in bytes)
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = & new memory
   ;
   ;         fail
   ;
   ;           carry set, errno = enomem
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl
   
   push hl                     ; save heap
   
   ld hl,6                     ; header size
   add hl,bc                   ; add space for header
   jp c, error_enomem_zc - 1
   
   ld a,d                      ; if p == 0 we are allocating, not resizing
   or e
   jr z, allocating

valid_p:

   ; try to resize block in place -- this is what we want to be fast
   
   ; de = p
   ; hl = request size
   ; stack = heap
   
   ld c,l
   ld b,h                      ; bc = request size
   
   ld hl,-5
   add hl,de
   
   ld d,(hl)
   dec hl                      ; hl = & block_p
   ld e,(hl)                   ; de = block_p->next = & block_next
   
   ex de,hl
   
   or a
   sbc hl,de                   ; hl = & block_next - block_p
   sbc hl,bc                   ; enough space for request?
   
   ex de,hl
   jr c, resize_fail
 
   ; resize is successful
   
   ; hl = & block_p
   ; bc = request size
   ; stack = heap
   
   inc hl
   inc hl
   ld (hl),c
   inc hl
   ld (hl),b                   ; block_p->committed = request size
   inc hl

   inc hl
   inc hl                      ; hl = p
   
   pop de
   ret                         ; carry is reset

;; BELOW WE DON'T CARE ABOUT SPEED SO WE GO FOR SIZE

resize_fail:

   ; hl = & block_p
   ; bc = request size
   ; stack = heap

   ; Other implementations try to merge block_p into the previous block
   ; and, failing that, then try to malloc sufficient space.
   ;
   ; We do something riskier and smaller :- we deallocate p and then
   ; do the malloc right away.  On failure, we have to restore p to the heap.
   ;
   ; Our malloc uses the largest available block in the heap to
   ; make further calls to realloc very fast.
   
   inc hl
   inc hl
   ld e,(hl)
   inc hl
   ld d,(hl)                   ; de = block_p->committed
   inc hl
   
   inc hl
   inc hl                      ; hl = p
   
   ; hl = p
   ; bc = request size
   ; de = block_p->committed
   ; stack = heap
   
   pop af
   push hl
   push de
   push bc
   push af
   
   ; hl = p
   ; stack = p, block_p->committed, request size, heap
   
   call __0_malloc_block_free  ; free(p)
   
   pop hl                      ; hl = heap
   call __malloc_largest_fit   ; find largest block in heap
   ex (sp),hl
   
   ; hl = request size
   ; bc = largest block size
   ; stack = p, block_p->committed, & block_largest
   
   scf
   sbc hl,bc                   ; can request be satisfied ?
   jr nc, realloc_fail

realloc_success:

   add hl,bc
   
   ; hl = request size
   ; stack = p, block_p->committed, & block_largest

   ld c,l
   ld b,h                      ; bc = request size
   pop hl                      ; hl = & block_largest
   
   call __malloc_block_allocate  ; allocate into block
   
   ; hl = new_p
   ; stack = p, block_p->committed
   
   ex de,hl                    ; de = new_p
   pop hl                      ; hl = block_p->committed
   
   ld bc,-6
   add hl,bc                   ; size of p allocation in bytes
   
   ld c,l
   ld b,h                      ; bc = num bytes to copy
   
   pop hl                      ; hl = p
   
   jp asm_memmove              ; copy data to new location

allocating:

   ex (sp),hl
   
   ; hl = heap
   ; stack = request size

   ; caller supplied p == 0 when means perform a malloc
   
   call __malloc_largest_fit   ; hl = & block_largest, bc = largest block size
   ex (sp),hl                  ; hl = request size

   scf
   sbc hl,bc                   ; can request be satisfied ?
   jp nc, error_enomem_zc - 1

   add hl,bc
   ld c,l
   ld b,h                      ; bc = request size
   
   pop hl                      ; hl = & block_largest
   jp __malloc_block_allocate  ; allocate into block

realloc_fail:

   ; stack = p, block_p->committed, & block_largest

   ; we are left with the sticky situation of restoring block_p in the heap
   
   pop bc
   pop bc                      ; bc = block_p->committed = "request size"
   pop hl                      ; hl = void *p
   
   dec hl
   ld d,(hl)
   dec hl
   ld e,(hl)                   ; de = block_p->prev = & block_prev = "& block"

   dec hl
   dec hl
   dec hl
   dec hl                      ; hl = & block_p = "& new_block"
   
   ld a,d
   or e
   jr nz, rejoin

   ; no previous block -- block is first in region
   
   ld e,l
   ld d,h

rejoin:

   ex de,hl
   call malloc_block_allocate_fixed
   jp error_enomem_zc
