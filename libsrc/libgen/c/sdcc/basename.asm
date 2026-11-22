; char *basename(char *path)

SECTION code_string

PUBLIC _basename

EXTERN asm_basename

_basename:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_basename
