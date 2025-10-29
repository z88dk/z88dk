
; Used by clang for copying structures
; void *___memcpy_stdc(void * restrict s1, const void * restrict s2, size_t n) __stdc;

IF __CPU_ZILOG__
SECTION code_clib
SECTION code_string

PUBLIC ___memcpy_stdc

EXTERN asm_memcpy

___memcpy_stdc:
   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   jp asm_memcpy
ENDIF
