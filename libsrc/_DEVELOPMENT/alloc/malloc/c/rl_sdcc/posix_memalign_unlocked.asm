
; ===============================================================
; Dec 2013
; ===============================================================
; 
; int posix_memalign_unlocked(void **memptr, size_t alignment, size_t size)
;
; Attempt to allocate size bytes aligned to alignment from the
; thread's heap.  Alignment must be an exact power of 2 and if
; it is not, it is rounded upward to the next power of 2.
;
; The pointer to allocated memory is stored in memptr.
;
; Return 0 on success or errno with carry set.
;
; Writes 0 to memptr without error indication if size == 0.
;
; ===============================================================

XDEF posix_memalign_unlocked

posix_memalign_unlocked:

   pop af
   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   push af
   
   INCLUDE "../../z80/asm_posix_memalign_unlocked.asm"
