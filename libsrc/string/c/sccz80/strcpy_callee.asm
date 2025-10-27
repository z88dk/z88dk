
; char *strcpy(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcpy_callee

EXTERN asm_strcpy

strcpy_callee:

   pop bc
   pop hl
   pop de
   push bc

IF __CLASSIC &&  __CPU_GBZ80__
   call asm_strcpy
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strcpy
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcpy_callee
defc _strcpy_callee = strcpy_callee
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strcpy_callee
defc ___strcpy_callee = strcpy_callee
ENDIF

