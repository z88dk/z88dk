
; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

PUBLIC strnchr_callee

EXTERN asm_strnchr

strnchr_callee:

   pop hl
   pop de
   pop bc
   ex (sp),hl

   jp asm_strnchr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnchr_callee
defc _strnchr_callee = strnchr_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strnchr_callee
defc ___strnchr_callee = strnchr_callee
ENDIF

