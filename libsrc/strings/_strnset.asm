; char *strnset(char *s, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strnset_sdcc
GLOBAL _strnset
GLOBAL strnset

defc _strnset = strnset

