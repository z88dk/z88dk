
; char *strpbrk(const char *s1, const char *s2)

SECTION seg_code_string

PUBLIC strpbrk

EXTERN asm_strpbrk

strpbrk:

   pop af
   pop de
   pop hl
   
   push hl
   push de
   push af
   
   jp asm_strpbrk
