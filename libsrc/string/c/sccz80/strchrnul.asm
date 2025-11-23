
; char *strchrnul(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strchrnul

EXTERN asm_strchrnul

strchrnul:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
IF __CLASSIC && __CPU_GBZ80__
   call asm_strchrnul
   ld d,h
   ld e,l
   ret
ELSE   
   jp asm_strchrnul
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strchrnul
defc _strchrnul = strchrnul
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strchrnul
defc ___strchrnul = strchrnul
ENDIF

