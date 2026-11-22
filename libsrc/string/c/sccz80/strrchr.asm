
; char *strrchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strrchr

EXTERN asm_strrchr

strrchr:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
IF __CLASSIC && __CPU_GBZ80__   
   call asm_strrchr
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strrchr
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrchr
defc _strrchr = strrchr
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strrchr
defc ___strrchr = strrchr
ENDIF

