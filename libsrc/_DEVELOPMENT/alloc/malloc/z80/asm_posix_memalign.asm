
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int posix_memalign(void **memptr, size_t alignment, size_t size)
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

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_posix_memalign

EXTERN __malloc_heap

EXTERN asm_heap_alloc_aligned, asm0_posix_memalign_unlocked

asm_posix_memalign:

   ; Aligned allocation with allocated address written to memptr
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
   call asm_heap_alloc_aligned
   
   jp asm0_posix_memalign_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_posix_memalign

EXTERN asm_posix_memalign_unlocked

defc asm_posix_memalign = asm_posix_memalign_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
