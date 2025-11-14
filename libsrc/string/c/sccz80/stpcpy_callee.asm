
; char *stpcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC stpcpy_callee

EXTERN asm_stpcpy

stpcpy_callee:

   pop bc
   pop hl
   pop de
   push bc
   
   jp asm_stpcpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _stpcpy_callee
defc _stpcpy_callee = stpcpy_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___stpcpy_callee
defc ___stpcpy_callee = stpcpy_callee
ENDIF

