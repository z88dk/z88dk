
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *heap_alloc_aligned(void *heap, size_t alignment, size_t size)
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

INCLUDE "config_private.inc"

SECTION code_clib
SECTION code_alloc_malloc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_MULTITHREAD & $01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_heap_alloc_aligned

EXTERN asm_heap_alloc_aligned_unlocked
EXTERN __heap_lock_acquire, __heap_lock_release_0, error_enolck_zc

asm_heap_alloc_aligned:

   ; Attempt to allocate memory at an address that is aligned to a power of 2
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

   call __heap_lock_acquire
   jp c, error_enolck_zc
   
   push de                       ; save void *heap
   call asm_heap_alloc_aligned_unlocked

   jp __heap_lock_release_0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

PUBLIC asm_heap_alloc_aligned

EXTERN asm_heap_alloc_aligned_unlocked

defc asm_heap_alloc_aligned = asm_heap_alloc_aligned_unlocked

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
