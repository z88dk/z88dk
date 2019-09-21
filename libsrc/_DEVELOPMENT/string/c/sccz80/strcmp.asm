
; int strcmp(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcmp

EXTERN asm_strcmp

strcmp:

   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   
   jp asm_strcmp

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcmp
defc _strcmp = strcmp
ENDIF

