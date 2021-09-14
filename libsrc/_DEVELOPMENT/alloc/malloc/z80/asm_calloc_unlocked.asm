
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *calloc_unlocked(size_t nmemb, size_t size)
;
; Allocate nmemb * size bytes from the current thread's heap and
; initialize that memory to 0.
;
; Returns 0 if nmemb*size == 0 without indicating error.
;
; ===============================================================

SECTION code_clib
SECTION code_alloc_malloc

PUBLIC asm_calloc_unlocked

EXTERN __malloc_heap

EXTERN asm_heap_calloc_unlocked

asm_calloc_unlocked:

   ; Allocate zero-initialized memory from the thread's default heap
   ; without locking
   ;
   ; enter : hl = uint nmemb
   ;         bc = uint size
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
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, bc, de, hl

   IF __CPU_INTEL__ || __CPU_GBZ80__
   ex de,hl
   ld hl,(__malloc_heap)
   ex de,hl
   ELSE
   ld de,(__malloc_heap)
   ENDIF
   jp asm_heap_calloc_unlocked
