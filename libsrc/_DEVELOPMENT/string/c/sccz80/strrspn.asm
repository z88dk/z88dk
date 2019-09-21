
; size_t strrspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

PUBLIC strrspn

EXTERN asm_strrspn

strrspn:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   
   jp asm_strrspn

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strrspn
defc _strrspn = strrspn
ENDIF

