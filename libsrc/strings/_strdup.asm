; char *strdup(const char * s)

SECTION code_clib
SECTION code_string

MODULE _strdup_sdcc
GLOBAL _strdup
GLOBAL strdup

defc _strdup = strdup

