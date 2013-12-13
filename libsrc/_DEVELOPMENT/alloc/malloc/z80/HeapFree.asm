
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void HeapFree(void *p)
;
; Return a previously allocated block to the heap for reuse.
;
; If p == 0, no action is taken.
;
; ===============================================================

XLIB HeapFree
XDEF asm_HeapFree, free, asm_free

LIB __0_malloc_block_free

HeapFree:
asm_HeapFree:
free:
asm_free:

   ; enter : hl = void *p
   ;
   ; exit  : none
   ;
   ; uses  : af, bc, de, hl

   ld a,h
   or l
   ret z                       ; if p == NULL

   jp __0_malloc_block_free

