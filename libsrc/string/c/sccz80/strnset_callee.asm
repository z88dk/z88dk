
; char *strnset(char *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strnset_callee

EXTERN asm_strnset

strnset_callee:

   pop hl
   pop bc
   pop de
   ex (sp),hl

   jp asm_strnset

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnset_callee
defc _strnset_callee = strnset_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strnset_callee
defc ___strnset_callee = strnset_callee
ENDIF

