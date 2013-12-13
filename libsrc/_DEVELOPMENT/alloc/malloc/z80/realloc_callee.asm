
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *realloc(void *p, size_t size)
;
; Implicitly uses the thread's heap for allocation.
;
; Resize the memory block p to size bytes.  If this cannot
; be done in-place, a new memory block is allocated and the
; data at address p is copied to the new block.
;
; If p == 0, an effective malloc is performed, except a
; successful allocation returns the largest block available
; in the heap to allow for further quick growth via realloc().
;
; If p != 0 and size == 0, the block is reduced to zero size
; but is not freed.  You must call free() to free blocks.
;
; If successful, returns ptr to the reallocated memory block,
; which may be p if the block was resized in place.
;
; If unsuccessful, returns 0.
;
; ===============================================================

INCLUDE "../../../crt_vars.inc"

XLIB realloc_callee
XDEF asm_realloc

LIB asm_HeapRealloc

realloc_callee:

   pop hl
   pop bc
   pop de
   push hl

asm_realloc:

   ; enter : de = void *p
   ;         bc = uint size
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
   jp asm_HeapRealloc
