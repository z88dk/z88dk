
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *aligned_alloc(size_t alignment, size_t size)
;
; Allocate size bytes from the thread's default heap at an
; address that is an integer multiple of alignment.
; Returns 0 with carry set on failure.
;
; If alignment is not an exact power of 2, it will be rounded up
; to the next power of 2.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_aligned_alloc

EXTERN __malloc_heap

EXTERN asm_heap_alloc_aligned

asm_aligned_alloc:

   ; Attempt to allocate memory at an address that is aligned to a power of 2
   ; from the thread's default heap
   ;
   ; enter : hl = size
   ;         bc = alignment (promoted to next higher power of two if necessary)
   ;
   ; exit  : success
   ;
   ;            hl = void *p_aligned could be zero if size == 0
   ;            carry reset
   ;
   ;         fail on alignment == $10000
   ;
   ;            hl = 0
   ;            carry set, errno = EINVAL
   ;
   ;         fail on memory not found
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errno = ENOLCK
   ;
   ; uses   : af, bc, de, hl

   ld de,(__malloc_heap)
   jp asm_heap_alloc_aligned

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_aligned_alloc

EXTERN asm_aligned_alloc_unlocked

defc asm_aligned_alloc = asm_aligned_alloc_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
