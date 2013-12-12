
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void free(void *p)
;
; Return a previously allocated block to the heap for reuse.
;
; If p == 0, no action is taken.
;
; ===============================================================

INCLUDE "../../crt_vars.inc"

XLIB free
XDEF asm_free

free:
asm_free:

   ; enter : hl = void *p
   ;
   ; exit  : hl = 0
   ;         carry set if p does not belong to heap
   ;
   ; uses  : af, bc, de, hl

   ld c,l
   ld b,h
   
   ld hl,(__heap)
   jp asm_HeapFree
