
; char *strtok(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

PUBLIC strtok

EXTERN asm_strtok

strtok:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
IF __CLASSIC && __CPU_GBZ80__
   call asm_strtok
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strtok
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtok
defc _strtok = strtok
ENDIF


; Clang bridge for Classic
IF __CLASSIC
PUBLIC ___strtok
defc ___strtok = strtok
ENDIF

