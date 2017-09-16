; size_t strcspn(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strcspn_callee_sdcc
GLOBAL _strcspn_callee
GLOBAL strcspn_callee

defc _strcspn_callee = strcspn_callee

