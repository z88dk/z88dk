
; char *strrchr(const char *s, int c)

SECTION code_clib
SECTION code_string

PUBLIC strrchr

EXTERN asm_strrchr

strrchr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strrchr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrchr
defc _strrchr = strrchr
ENDIF

