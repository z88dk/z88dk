; size_t strlen(const char *s)

SECTION code_clib
SECTION code_string

MODULE _strlen_sdcc
GLOBAL _strlen
GLOBAL strlen

defc _strlen = strlen

