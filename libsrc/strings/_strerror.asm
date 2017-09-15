; char *strerror(int errnum)

SECTION code_clib
SECTION code_string

MODULE _strerror_sdcc
GLOBAL _strerror
GLOBAL strerror

defc _strerror = strerror

