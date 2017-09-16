; char *strncat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strncat_sdcc
GLOBAL _strncat
GLOBAL strncat

defc _strncat = strncat

