; char *pathnice(char *path)

SECTION code_string

PUBLIC _pathnice

EXTERN asm_pathnice

_pathnice:

   pop af
   pop hl
   
   push hl
   push af
   
   jp asm_pathnice
