
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *ba_addmem(unsigned char q, size_t num, size_t size, void *addr)
;
; Add num memory blocks to queue.  Each block is size bytes
; large and uses memory starting at address addr.
;
; size must be >= 2 but is not checked.  The actual memory space
; occupied by each block is (size + 1) bytes, the single extra
; byte being a hidden queue identifier.
;
; ===============================================================

XDEF ba_addmem_callee

ba_addmem_callee:

   pop af
   pop de
   pop hl
   pop bc
   pop ix
   push af
   
   ld a,ixl
   
   INCLUDE "../../z80/asm_ba_addmem.asm"
