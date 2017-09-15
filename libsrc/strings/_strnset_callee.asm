; char *strnset(char *s, int c, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strnset_callee_sdcc
GLOBAL _strnset_callee
GLOBAL strnset_callee

defc _strnset_callee = strnset_callee

