; int strcoll(const char *s1, const char *s2)

SECTION code_clib
SECTION code_string

MODULE _strcoll_sdcc
GLOBAL _strcoll
GLOBAL strcoll

defc _strcoll = strcoll

