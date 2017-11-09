
; long strtol( const char * restrict nptr, char ** restrict endptr, int base)

SECTION code_clib
SECTION code_stdlib

PUBLIC strtol

EXTERN asm_strtol

strtol:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af
   
   jp asm_strtol

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtol
defc _strtol = strtol
ENDIF

