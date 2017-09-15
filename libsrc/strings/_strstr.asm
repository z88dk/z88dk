; char *strstr(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strstr_sdcc
GLOBAL _strstr
GLOBAL strstr

defc _strstr = strstr

