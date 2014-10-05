
; char *strchr(const char *s, int c)

SECTION seg_code_string

PUBLIC strchr

EXTERN asm_strchr

strchr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strchr
