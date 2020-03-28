
; char *strnchr(const char *s, size_t n, int c)

SECTION code_clib
SECTION code_string

PUBLIC strnchr_callee

EXTERN asm_strnchr

strnchr_callee:
   pop af
   pop de
   pop bc
   pop hl
   push af
   jp asm_strnchr

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnchr_callee
defc _strnchr_callee = strnchr_callee
ENDIF

