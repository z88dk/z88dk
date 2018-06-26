; char *tmpnam(char *s)

SECTION code_env

PUBLIC env_tmpnam

EXTERN asm_env_tmpnam

defc env_tmpnam = asm_env_tmpnam
