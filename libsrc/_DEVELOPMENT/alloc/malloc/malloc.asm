
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *malloc(size_t size)
;
; Allocate size bytes from the current thread's heap, returning
; ptr to the allocated memory or 0 on failure.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB malloc
XDEF asm_malloc

LIB asm_HeapAlloc

malloc:
asm_malloc:

   ; enter : hl = unsigned int size
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = ptr to allocated memory, could be 0 if size == 0
   ;
   ;         fail on insufficient memory
   ;
   ;           carry set, enomem
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl

   ld de,(__heap)
   jp asm_HeapAlloc
