
; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncpy_callee

EXTERN asm_strncpy

strncpy_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   jp asm_strncpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncpy_callee
defc _strncpy_callee = strncpy_callee
ENDIF

