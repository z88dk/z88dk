
; char *stpcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC stpcpy

EXTERN asm_stpcpy

stpcpy:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   
   jp asm_stpcpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _stpcpy
defc _stpcpy = stpcpy
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___stpcpy
defc ___stpcpy = stpcpy
ENDIF

