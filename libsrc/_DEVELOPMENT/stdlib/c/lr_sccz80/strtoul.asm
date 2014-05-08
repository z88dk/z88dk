
; unsigned long strtoul( const char * restrict nptr, char ** restrict endptr, int base)

PUBLIC strtoul

EXTERN asm_strtoul

strtoul:

   pop af
   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   push af

   jp asm_strtoul
