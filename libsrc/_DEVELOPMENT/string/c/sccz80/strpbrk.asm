
; char *strpbrk(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strpbrk

EXTERN asm_strpbrk

strpbrk:

   pop de
   pop de
   pop hl
   
   push hl
   push de
   push de
IF __CLASSIC && __CPU_GBZ80__
   call asm_strpbrk
   ld d,h
   ld e,l
   ret
ELSE
   jp asm_strpbrk
ENDIF

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strpbrk
defc _strpbrk = strpbrk
ENDIF

