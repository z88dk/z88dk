
; BSD
; void bcopy(const void *src, void *dst, size_t len)

SECTION code_clib
SECTION code_string

PUBLIC bcopy

EXTERN asm_bcopy

bcopy:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_bcopy
