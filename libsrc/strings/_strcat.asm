; char *strcat(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

MODULE _strcat_sdcc
GLOBAL _strcat
GLOBAL strcat

defc _strcat = strcat

