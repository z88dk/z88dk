
; BSD
; void bcopy_callee(const void *src, void *dst, size_t len)

SECTION code_clib
SECTION code_string

PUBLIC _bcopy_callee

EXTERN asm_bcopy

_bcopy_callee:

   pop af
   pop hl
   pop de
   pop bc
   push af
   
   jp asm_bcopy
