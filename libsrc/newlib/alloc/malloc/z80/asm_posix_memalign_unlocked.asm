
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int posix_memalign_unlocked(void **memptr, size_t alignment, size_t size)
;
; Attempt to allocate size bytes aligned to alignment from the
; thread's heap.  Alignment must be an exact power of 2 and if
; it is not, it is rounded upward to the next power of 2.
;
; The pointer to allocated memory is stored in memptr.
;
; Return 0 on success or errno with carry set.
;
; Writes 0 to memptr without error indication if size == 0.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_posix_memalign_unlocked
PUBLIC asm0_posix_memalign_unlocked

EXTERN __malloc_heap, _errno

EXTERN asm_heap_alloc_aligned_unlocked, error_znc

asm_posix_memalign_unlocked:

   ; Aligned allocation with allocated address written to memptr without locking
   ;
   ; enter : de = void **memptr
   ;         hl = size
   ;         bc = alignment (promoted to next higher power of two if necessary)
   ;
   ; exit  : *memptr = ptr to allocated memory (zero on error)
   ;
   ;         success
   ;
   ;            hl = 0
   ;            carry reset
   ;
   ;         fail
   ;
   ;            hl = ENOMEM, EINVAL or ENOLCK
   ;            carry set
   ;
   ; uses  : af, bc, de, hl

   push de                     ; save memptr
   
   ld de,(__malloc_heap)
   call asm_heap_alloc_aligned_unlocked
   
asm0_posix_memalign_unlocked:

   pop de
   ex de,hl
   
   ld (hl),e
   inc hl
   ld (hl),d                   ; *memptr = allocation address
   
   jp nc, error_znc            ; if no error
   
   ld hl,(_errno)              ; otherwise error is stored in errno
   ret                         ; (this is safe in z88dk)
