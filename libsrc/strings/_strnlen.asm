; size_t strnlen(const char *s, size_t maxlen)

SECTION code_clib
SECTION code_string

MODULE _strnlen_sdcc
GLOBAL _strnlen
GLOBAL strnlen

defc _strnlen = strnlen

