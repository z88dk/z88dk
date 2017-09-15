; char *strlwr(char *s)

SECTION code_clib
SECTION code_string

MODULE _strlwr_sdcc
GLOBAL _strlwr
GLOBAL strlwr

defc _strlwr = strlwr

