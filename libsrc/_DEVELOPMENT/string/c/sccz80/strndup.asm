
; char *strndup(const char *s, size_t n)

SECTION code_clib
SECTION code_string

PUBLIC strndup

EXTERN asm_strndup

strndup:

   pop de
   pop bc
   pop hl
   
   push hl
   push bc
   push de
   
   jp asm_strndup

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strndup
defc _strndup = strndup
ENDIF

