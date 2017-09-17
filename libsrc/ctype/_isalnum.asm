; int isalnum(int c)

SECTION code_clib
SECTION code_string

MODULE _isalnum_sdcc
GLOBAL _isalnum
GLOBAL isalnum

defc _isalnum = isalnum

