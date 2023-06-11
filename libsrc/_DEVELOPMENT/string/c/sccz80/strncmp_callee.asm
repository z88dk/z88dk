
; int strncmp(const char *s1, const char *s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncmp_callee

EXTERN asm_strncmp

strncmp_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   jp asm_strncmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncmp_callee
defc _strncmp_callee = strncmp_callee
ENDIF

