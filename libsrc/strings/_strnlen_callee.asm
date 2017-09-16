; size_t strnlen(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

MODULE _strnlen_callee_sdcc
GLOBAL _strnlen_callee
GLOBAL strnlen_callee

defc _strnlen_callee = strnlen_callee

