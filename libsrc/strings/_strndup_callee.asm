; char *strndup(const char *s, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strndup_callee_sdcc
GLOBAL _strndup_callee
GLOBAL strndup_callee

defc _strndup_callee = strndup_callee

