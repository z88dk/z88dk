; int isascii(int c)

SECTION code_clib
SECTION code_string

MODULE _isascii_sdcc
GLOBAL _isascii
GLOBAL isascii

defc _isascii = isascii

