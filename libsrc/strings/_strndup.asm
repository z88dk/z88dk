; char *strndup(const char *s, size_t n)

SECTION code_clib
SECTION code_string

MODULE _strndup_sdcc
GLOBAL _strndup
GLOBAL strndup

defc _strndup = strndup

