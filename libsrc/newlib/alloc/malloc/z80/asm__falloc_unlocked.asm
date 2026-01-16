
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *_falloc(void *p, size_t size)
;
; Attempt to allocate size bytes from the thread's heap at
; fixed address p.  Returns p or 0 with carry set on failure.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm__falloc_unlocked

EXTERN __malloc_heap

EXTERN asm_heap_alloc_fixed_unlocked

asm__falloc_unlocked:

   ; Attempt to allocate memory from the thread's default heap
   ; at a fixed address without locking
   ;
   ; enter : bc = void *p
   ;         hl = size
   ;
   ; exit  : success
   ;
   ;            hl = void *p (zero size allocation will occur)
   ;            carry reset
   ;
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errono = ENOLCK
   ;
   ;         fail on insufficient memory
   ;
   ;            hl = 0
   ;            carry set, errno = ENOMEM
   ;
   ; uses  : af, bc, de, hl

   ld de,(__malloc_heap)
   jp asm_heap_alloc_fixed_unlocked
