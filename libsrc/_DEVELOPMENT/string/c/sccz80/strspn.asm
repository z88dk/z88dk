
; size_t strspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strspn

EXTERN asm_strspn

strspn:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   
   jp asm_strspn

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strspn
defc _strspn = strspn
ENDIF

