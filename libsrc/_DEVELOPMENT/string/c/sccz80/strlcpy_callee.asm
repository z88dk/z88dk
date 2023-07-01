
; size_t strlcpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strlcpy_callee

EXTERN asm_strlcpy

strlcpy_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl
   ex de,hl

   jp asm_strlcpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strlcpy_callee
defc _strlcpy_callee = strlcpy_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strlcpy_callee
defc ___strlcpy_callee = strlcpy_callee
ENDIF

