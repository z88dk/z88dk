; size_t strrcspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

MODULE _strrcspn_callee_sdcc
GLOBAL _strrcspn_callee
GLOBAL strrcspn_callee

defc _strrcspn_callee = strrcspn_callee

