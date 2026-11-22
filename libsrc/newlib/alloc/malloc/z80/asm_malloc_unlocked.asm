
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *malloc_unlocked(size_t size)
;
; Allocate size bytes from the current thread's heap, returning
; ptr to the allocated memory or 0 with carry set on failure.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_malloc_unlocked

EXTERN __malloc_heap

EXTERN asm_heap_alloc_unlocked

asm_malloc_unlocked:

   ; Allocate memory from the thread's default heap without locking
   ;
   ; enter : hl = size
   ;
   ; exit  : success
   ;
   ;            hl = address of allocated memory, 0 if size == 0
   ;            carry reset
   ;
   ;         fail on insufficient memory
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   ld de,(__malloc_heap)
   jp asm_heap_alloc_unlocked
