
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *calloc(size_t nmemb, size_t size)
;
; Allocate nmemb*size bytes from the current thread's heap and
; initialize that memory to 0.
;
; Returns 0 if nmemb*size == 0 without indicating error.
;
; ===============================================================

INCLUDE "../../../crt_vars.inc"

XLIB calloc_callee
XDEF asm_calloc

LIB asm_HeapCalloc

calloc_callee:

   pop hl
   pop de
   ex (sp),hl

asm_calloc:

   ; enter : hl = nmemb
   ;         de = size
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = ptr to allocated memory
   ;
   ;         fail
   ;
   ;           carry set, enomem
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl

   ld bc,(__heap)
   jp asm_HeapCalloc
