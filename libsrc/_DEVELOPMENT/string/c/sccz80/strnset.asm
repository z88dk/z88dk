
; char *strnset(char *s, int c, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strnset

EXTERN asm_strnset

strnset:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_strnset

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnset
defc _strnset = strnset
ENDIF

