
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *HeapAllocAligned(void *heap, size_t alignment, size_t size)
;
; Allocate size bytes from the heap at an address that is an
; integer multiple of alignment.  Return 0 on failure.
;
; If alignment is not an exact power of 2, it will be rounded up
; to the next power of 2.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

XLIB HeapAllocAligned_callee
XDEF asm_HeapAllocAligned

LIB error_enomem_zc, error_einval_zc, l_power_2_bc
LIB __malloc_region_info, __malloc_first_fit_aligned, __malloc_block_allocate_fixed

HeapAllocAligned_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

asm_HeapAllocAligned:

   ; enter : de = void *heap
   ;         hl = size_t size
   ;         bc = alignment (exact power of 2)
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = ptr to aligned memory, could be 0
   ;
   ;         fail
   ;
   ;            carry set, enomem / einval
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl

   ld a,h
   or l
   ret z                       ; if size == 0
   
   call l_power_2_bc           ; bc = power of 2 >= bc
   jp c, error_einval_zc       ; if alignment = 2^16
   
   dec bc                      ; bc = alignment - 1
   ld a,b
   or c
   jp z, asm_HeapAlloc         ; if alignment == 1
   
   push bc                     ; save alignment - 1
   
   ld bc,6                     ; header size
   add hl,bc                   ; add space for header
   jp c, error_enomem_zc - 1
   
   ld c,l
   ld b,h
   ex de,hl
   
region_loop:

   ; bc = request size
   ; hl = & region
   ; stack = alignment - 1
   
   push hl                     ; save region
   
   call __malloc_region_info
   jp z, error_enomem_zc - 2   ; no more regions to search
   
   sbc hl,bc                   ; region size - request size
   
   pop hl
   ex de,hl                    ; hl = & next region, de = & region
   
   jr c, region_loop           ; if region is too small
   
   pop af
   push hl                     ; save & next region
   push af

search_region:

   ld hl,4
   add hl,de
   
   ; bc = request size
   ; hl = & first block in region
   ; stack = & next_region, alignment - 1
   
   ld e,c
   ld d,b                      ; de = request size
   pop bc                      ; bc = alignment - 1
   
   call __malloc_first_fit_aligned
   jr nc, found_memory
   
   ; de = request size
   ; bc = alignment - 1
   ; stack = & next_region
   
   pop hl
   push bc
   
   ld c,e
   ld b,d
   
   jp region_loop              ; better luck in next region

found_memory:
   
   ; de = & block_p = & block_new
   ; bc = request size
   ; hl = & block
   ; stack = & next_region
   
   pop af
   jp __malloc_block_allocate_fixed  ; allocate at fixed memory address
