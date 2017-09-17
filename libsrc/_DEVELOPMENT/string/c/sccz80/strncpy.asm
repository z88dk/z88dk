
; char *strncpy(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strncpy

EXTERN asm_strncpy

strncpy:

   pop af
   pop bc
   pop hl
   pop de
   
   push de
   push hl
   push bc
   push af
   
   jp asm_strncpy

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strncpy
defc _strncpy = strncpy
ENDIF

