; char *pathnice(char *path)

SECTION code_string

PUBLIC _pathnice_fastcall

EXTERN asm_pathnice

defc _pathnice_fastcall = asm_pathnice
