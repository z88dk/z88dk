; char *dirname(char *path)

SECTION code_string

PUBLIC _dirname

EXTERN asm_dirname

_dirname:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_dirname
