
; size_t strcspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

PUBLIC strcspn

EXTERN asm_strcspn

strcspn:

   pop bc
   pop de
   pop hl
   
   push hl
   push de
   push bc
   
   jp asm_strcspn

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strcspn
defc _strcspn = strcspn
ENDIF

