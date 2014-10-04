
; ===============================================================
; Dec 2013
; ===============================================================
; 
; void *obstack_blank(struct obstack *ob, int size)
;
; Attempt to resize the currently growing object by
; signed size bytes.
;
; If size < 0, the object will not be allowed to shrink
; past its start address.
;
; If size > 0, additional bytes will be uninitialized.
;
; ===============================================================

SECTION seg_code_obstack

PUBLIC obstack_blank_callee

obstack_blank_callee:

   pop hl
   pop bc
   ex (sp),hl
   
   INCLUDE "alloc/obstack/z80/asm_obstack_blank.asm"
