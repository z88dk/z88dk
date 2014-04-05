
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *malloc(size_t size)
;
; Allocate size bytes from the current thread's heap, returning
; ptr to the allocated memory or 0 with carry set on failure.
;
; Returns 0 if size == 0 without indicating error.
;
; ===============================================================

XLIB asm_malloc
XDEF asm_malloc_lib

XREF __heap

LIB asm_heap_alloc

asm_malloc:
asm_malloc_lib:

   ; Allocate memory from the thread's default heap
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
   ;         fail on lock acquisition
   ;
   ;            hl = 0
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, bc, de, hl
   
   ld de,(__heap)
   jp asm_heap_alloc
