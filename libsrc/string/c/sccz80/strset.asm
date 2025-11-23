
; char* strset(char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strset

EXTERN asm_strset

strset:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strset
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strset
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strset
defc _strset = strset
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strset
defc ___strset = strset
ENDIF

