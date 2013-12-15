
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *memalign(size_t alignment, size_t size)
;
; Allocate size bytes from the thread's heap at an address
; that is a multiple of alignment.  Alignment is always an
; exact power of 2 and if it is not, it is rounded upward
; to the next power of 2.
;
; Returns 0 if size = 0 without indicating error.
;
; ===============================================================

INCLUDE "../../../crt_vars.inc"

XLIB memalign_callee
XDEF asm_memalign

memalign_callee:

   pop de
   pop hl
   pop bc
   push de

asm_memalign:

   ; enter : hl = size (raw request size)
   ;         bc = alignment (exact power of 2)
   ;
   ; exit  : success
   ;
   ;           carry reset
   ;           hl = ptr to allocated memory, could be 0 if size == 0
   ;
   ;         fail on aligned block of sufficient size not found
   ;
   ;           carry set, enomem
   ;           hl = 0
   ;
   ; uses  : af, bc, de, hl

   ld de,(__heap)
   jp asm_HeapAllocAligned
