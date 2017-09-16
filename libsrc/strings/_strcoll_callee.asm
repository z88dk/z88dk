; int strcoll(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strcoll_callee_sdcc
GLOBAL _strcoll_callee
GLOBAL strcoll_callee

defc _strcoll_callee = strcoll_callee

