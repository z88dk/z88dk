
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_alloc_aligned_unlocked(void *heap, size_t alignment, size_t size)
;
; Allocate size bytes from the heap at an address that is an
; integer multiple of alignment.
;
; Returns 0 with carry set on failure.
;
; If alignment is not an exact power of 2, it will be rounded up
; to the next power of 2.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_heap_alloc_aligned_unlocked

EXTERN __heap_place_block, __heap_allocate_block, l_andc_hl_bc
EXTERN l_power_2_bc, asm_heap_alloc_unlocked, error_enomem_zc, error_einval_zc

asm_heap_alloc_aligned_unlocked:

   ; Attempt to allocate memory at an address that is aligned to a power of 2
   ; without locking
   ;
   ; enter : de = void *heap
   ;         hl = size
   ;         bc = alignment (promoted to next higher power of two if necessary)
   ;
   ; exit  : success
   ;
   ;            hl = void *p_aligned could be zero if size == 0
   ;            carry reset
   ;
   ;         fail on alignment == 2^16
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail on memory not found
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses   : af, bc, de, hl

   ld a,h
   or l
   ret z                       ; if size == 0

   call l_power_2_bc           ; bc = power of two >= bc
   jp c, error_einval_zc       ; if alignment == 2^16

   dec bc                      ; bc = alignment - 1
   
   ld a,b
   or c
   jp z, asm_heap_alloc_unlocked  ; if no alignment (alignment == 1)

   ; de = void *heap
   ; hl = size
   ; bc = alignment - 1

   push bc                     ; save alignment - 1
   
   ld bc,6                     ; sizeof(heap header)
   add hl,bc
   jp c, error_enomem_zc
   
   ex de,hl                    ; de = gross request size
   
   ld bc,6                     ; sizeof(mutex)
   add hl,bc                   ; hl = & first block in heap

   ; hl = & block
   ; de = gross request size
   ; stack = alignment - 1

   ex de,hl
   ex (sp),hl
   push hl
   ex de,hl

block_loop:
   
   ; hl = & block
   ; stack = gross request size, alignment - 1

   ld e,l
   ld d,h                      ; de = & block

   ; check if end of heap reached
   
   ld a,(hl)
   inc hl
   or (hl)
   
   jp z, error_enomem_zc - 2   ; if end of heap reached

   inc hl                      ; hl = & block.committed

   ; compute first free aligned address in this block
   
   ld c,(hl)
   inc hl
   ld b,(hl)                   ; bc = block->committed
   
   ld a,b
   or c
   jr nz, committed_nonzero
   
   ; block->committed == 0
   ; this means the request can be overlayed on top
   ; of the header so must test for this case
   
   ; de = & block
   ; hl = & block.committed + 1b
   ; stack = gross request size, alignment - 1
   
   inc hl
   inc hl
   inc hl                      ; hl = & block.mem[

   
   ; check if memory address is aligned
   
   pop bc                      ; bc = alignment - 1
   push bc
   
   ld a,l
   and c
   jr nz, overlay_unaligned
   
   ld a,h
   and b
   jr nz, overlay_unaligned

   ; overlay aligns

   ; de = & block
   ; stack = gross request size, alignment - 1

   ld l,e
   ld h,d
   
   pop af
   pop bc
   push bc
   push af
   
   jr test_fit

overlay_unaligned:

   ; de = & block
   ; stack = gross request size, alignment - 1

   ld bc,6                     ; step over the zero-committed header

committed_nonzero:

  ; de = & block
  ; bc = block->committed
  ; stack = gross request size, alignment - 1

   ld hl,6                     ; sizeof(heap header)
   add hl,bc
   add hl,de                   ; first free address after another header added
   jp c, error_enomem_zc - 2
   
   ; compute next aligned address
   
   pop bc                      ; bc = alignment - 1

   add hl,bc
   jp c, error_enomem_zc - 1
   call l_andc_hl_bc           ; hl = hl & ~bc

   ; de = & block
   ; hl = next aligned address
   ; bc = alignment - 1
   ; stack = gross request size

   pop af
   push af
   push bc
   push af

   ; stack = gross request size, alignment - 1, gross request size
   
   ld bc,-6                    ; sizeof(heap header)
   add hl,bc
   
   pop bc                      ; bc = gross request size
   ex de,hl

test_fit:
   
   ; hl = & block
   ; de = & block_new = proposed aligned block location
   ; bc = gross request size
   ; stack = gross request size, alignment - 1
   
   ; see if proposed block fits
   
   call __heap_place_block
   jr nc, success              ; if block fits
   
   ; try next block
   
   ; hl = & block
   ; stack = gross request size, alignment - 1

   ld a,(hl)
   inc hl
   ld h,(hl)
   ld l,a
   
   jr block_loop

success:

   ; hl = & block
   ; de = & block_new
   ; bc = gross request size
   ; stack = gross request size, alignment - 1
   
   call __heap_allocate_block  ; place the block
   
   pop de
   pop de                      ; junk two items on stack

   ret
