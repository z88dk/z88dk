; char *basename(char *path)

SECTION code_string

PUBLIC basename

EXTERN asm_basename

defc basename = asm_basename
