; unsigned char mkstemp(char *template)

SECTION code_env

PUBLIC env_mkstemp

EXTERN asm_env_mkstemp

defc env_mkstemp = asm_env_mkstemp
