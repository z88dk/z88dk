
; char *strrchr(const char *s, int c)

SECTION seg_code_string

PUBLIC strrchr

EXTERN asm_strrchr

strrchr:

   pop af
   pop bc
   pop hl
   
   push hl
   push bc
   push af
   
   jp asm_strrchr
