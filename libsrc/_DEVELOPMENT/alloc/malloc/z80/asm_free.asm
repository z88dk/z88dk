
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void free(void *p)
;
; Deallocate memory previously allocated at p from the thread's
; default heap.
;
; If p == 0, function returns without performing an action.
;
; ===============================================================

XLIB asm_free
XDEF asm_free_lib

XREF __heap

LIB asm_heap_free

asm_free:
asm_free_lib:

   ; Return the memory block to the thread's default heap
   ;
   ; enter : hl = void *p
   ;
   ; exit  : success
   ;
   ;            carry reset
   ;
   ;         fail on lock acquisition
   ;
   ;            de = void *p
   ;            carry set, errno = ENOLCK
   ;
   ; uses  : af, de, hl

   ld de,(__heap)
   jp asm_heap_free
