
; size_t strrcspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrcspn

EXTERN asm_strrcspn

strrcspn:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   
   jp asm_strrcspn

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrcspn
defc _strrcspn = strrcspn
ENDIF

