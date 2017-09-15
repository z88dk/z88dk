; char *strtok(char * restrict s1, const char * restrict s2)

SECTION code_clib
SECTION code_string

MODULE _strtok_sdcc
GLOBAL _strtok
GLOBAL strtok

defc _strtok = strtok

