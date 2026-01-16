
; char *strcat(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strcat

EXTERN asm_strcat

strcat:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
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
PUBLIC _strcat
defc _strcat = strcat
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strcat
defc ___strcat = strcat
ENDIF

