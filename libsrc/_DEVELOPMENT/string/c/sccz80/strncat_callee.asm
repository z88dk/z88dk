
; char *strncat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncat_callee

EXTERN asm_strncat

strncat_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   jp asm_strncat

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncat_callee
defc _strncat_callee = strncat_callee
ENDIF

