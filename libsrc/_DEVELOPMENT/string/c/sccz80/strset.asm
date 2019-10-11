
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
   
   jp asm_strset

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strset
defc _strset = strset
ENDIF

