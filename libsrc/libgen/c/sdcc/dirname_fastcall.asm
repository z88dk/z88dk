; char *dirname(char *path)

SECTION code_string

PUBLIC _dirname_fastcall

EXTERN asm_dirname

defc _dirname_fastcall = asm_dirname
