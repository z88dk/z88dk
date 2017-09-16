; size_t strrspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

MODULE _strrspn_callee_sdcc
GLOBAL _strrspn_callee
GLOBAL strrspn_callee

defc _strrspn_callee = strrspn_callee

