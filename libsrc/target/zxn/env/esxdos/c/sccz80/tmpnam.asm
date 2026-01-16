; char *tmpnam(char *s)

SECTION code_env

PUBLIC tmpnam

EXTERN asm_tmpnam

defc tmpnam = asm_tmpnam
