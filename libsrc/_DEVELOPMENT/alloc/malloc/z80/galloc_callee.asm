
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *galloc(void *p, int resize)
;
; Implicitly uses the thread's heap for allocation.
;
; Attempts to grow or shrink block p by signed resize bytes.
; This is a thin layer on top of realloc().
;
; Non-standard function used internally by the C library.
; See HeapRealloc() for exit conditions.
;
; ===============================================================

INCLUDE "../../../crt_vars.inc"

XLIB galloc_callee
XDEF asm_galloc

LIB asm_HeapGalloc

galloc_callee:

   pop hl
   pop bc
   pop de
   push hl

asm_galloc:

   ; enter : de = void *p
   ;         bc = int resize (signed)
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = & new memory
   ;
   ;         fail
   ;
   ;           carry set, errno = enomem
   ;
   ; uses  : af, bc, de, hl

   ld hl,(__heap)              ; thread's heap
   jp asm_HeapGalloc
