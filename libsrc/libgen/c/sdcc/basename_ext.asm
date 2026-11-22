; char *basename_ext(char *path)

SECTION code_string

PUBLIC _basename_ext

EXTERN asm_basename_ext

_basename_ext:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_basename_ext
