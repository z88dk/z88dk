; size_t strlcat(char * restrict s1, const char * restrict s2, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strlcat_sdcc
GLOBAL _strlcat
GLOBAL strlcat

defc _strlcat = strlcat

