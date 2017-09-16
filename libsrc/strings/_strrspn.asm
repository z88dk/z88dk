; size_t strrspn(const char *str, const char *cset)

SECTION code_clib
SECTION code_string

MODULE _strrspn_sdcc
GLOBAL _strrspn
GLOBAL strrspn

defc _strrspn = strrspn

