
; size_t strnlen(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

PUBLIC strnlen

EXTERN asm_strnlen

strnlen:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   
   jp asm_strnlen

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strnlen
defc _strnlen = strnlen
ENDIF

