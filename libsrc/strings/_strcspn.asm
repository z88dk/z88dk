; size_t strcspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strcspn_sdcc
GLOBAL _strcspn
GLOBAL strcspn

defc _strcspn = strcspn

