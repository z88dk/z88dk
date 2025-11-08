; unsigned char mkstemp_ex(char *template)

SECTION code_env

PUBLIC mkstemp_ex

EXTERN asm_mkstemp_ex

defc mkstemp_ex = asm_mkstemp_ex
