
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
   
   jp asm_strpbrk

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strpbrk
defc _strpbrk = strpbrk
ENDIF

