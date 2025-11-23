; char *basename(char *path)

SECTION code_string

PUBLIC _basename_fastcall

EXTERN asm_basename

defc _basename_fastcall = asm_basename
