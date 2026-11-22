; char *getenv(const char *name)

SECTION code_env

PUBLIC getenv

EXTERN asm_getenv

defc getenv = asm_getenv
