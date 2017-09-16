; char* strset(char *s, int c)

SECTION code_clib
SECTION code_string

MODULE _strset_sdcc
GLOBAL _strset
GLOBAL strset

defc _strset = strset

