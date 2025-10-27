
; char *strcat(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcat_callee

EXTERN asm_strcat

strcat_callee:

   pop bc
   pop hl
   pop de
   push bc

IF __CLASSIC && __CPU_GBZ80__
   call asm_strcat
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strcat
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcat_callee
defc _strcat_callee = strcat_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strcat_callee
defc ___strcat_callee = strcat_callee
ENDIF

