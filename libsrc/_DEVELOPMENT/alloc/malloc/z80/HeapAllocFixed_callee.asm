
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *HeapAllocFixed(void *heap, void *p, size_t size)
;
; Attempt to allocate size bytes from the heap at fixed
; address p.  The allocation will fail if the heap does
; not contain enough free memory at address p.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

XLIB HeapAllocFixed_callee
XDEF asm_HeapAllocFixed

LIB error_enomem_zc, __malloc_region_locate, __malloc_block_locate
LIB __malloc_block_adequate, __malloc_block_allocate_fixed

HeapAllocFixed_callee:

   pop af
   pop hl
   pop bc
   pop de
   push af

asm_HeapAllocFixed:

   ; enter : bc = void *p
   ;         de = void *heap
   ;         hl = size_t size
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;            hl = p or 0 if size == 0
   ;
   ;         fail
   ;
   ;            carry set, enomem
   ;            hl = 0
   ;
   ; uses  : af, bc, de, hl

   ld a,h                      ; if size == 0
   or l
   ret z

   push de                     ; save heap

   ld de,6
   add hl,de                   ; add header to size
   jp c, error_enomem_zc - 1   ; if size too large
   
   ex (sp),hl
   
region_search:

   ; bc = void *p
   ; hl = heap
   ; stack = request size
   
   call __malloc_region_locate
   jp c, error_enomem_zc - 1   ; if p is not in heap
   
block_search:

   ; de = & region that could contain p
   ; bc = void *p
   ; stack = request size
   
   call __malloc_block_locate
   jp c, error_enomem_zc - 1   ; if p is not in heap
   
   ; bc = & would-be block_p = & block_p
   ; de = & block containing p = & block
   ; stack = request size

   ld l,c
   ld h,b                      ; hl = & block_p
   pop bc                      ; bc = request size
   
   push de                     ; save & block
   call __malloc_block_adequate
   pop hl                      ; hl = & block
   
   ; bc = request size
   ; hl = & block
   ; de = & block_p

   jp nc, __malloc_block_allocate_fixed
   jp error_enomem_zc          ; if insufficient space at address p
