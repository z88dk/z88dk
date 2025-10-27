; char *basename_ext(char *path)

SECTION code_string

PUBLIC _basename_ext_fastcall

EXTERN asm_basename_ext

defc _basename_ext_fastcall = asm_basename_ext
