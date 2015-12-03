
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memalign_unlocked(size_t alignment, size_t size)
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

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_memalign_unlocked

EXTERN asm_aligned_alloc_unlocked

defc asm_memalign_unlocked = asm_aligned_alloc_unlocked

   ; Attempt to allocate memory at an address that is aligned to a power of 2
   ; from the thread's default heap without locking
   ;
   ; enter : hl = size
   ;         bc = alignment (promoted to next higher power of two if necessary)
   ;
   ; exit  : success
   ;
   ;            hl = void *p_aligned could be zero if size == 0
   ;            carry reset
   ;
   ;         fail on alignment = $10000
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
