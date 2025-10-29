
; void *_memmove_stdc(void *s1, const void *s2, size_t n) __stdc

IF __CPU_ZILOG__
SECTION code_clib
SECTION code_string

PUBLIC ___memmove_stdc

EXTERN asm_memmove

___memmove_stdc:
   pop af
   pop de
   pop hl
   pop bc
   
   push bc
   push hl
   push de
   push af
   jp asm_memmove
ENDIF

