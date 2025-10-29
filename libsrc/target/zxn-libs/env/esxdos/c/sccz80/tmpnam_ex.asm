; char *tmpnam_ex(char *template)

SECTION code_env

PUBLIC tmpnam_ex

EXTERN asm_tmpnam_ex

defc tmpnam_ex = asm_tmpnam_ex
