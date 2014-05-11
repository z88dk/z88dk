
; size_t strcspn(const char *s1, const char *s2)

PUBLIC strcspn

EXTERN asm_strcspn

strcspn:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strcspn
