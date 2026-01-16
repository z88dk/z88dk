
; intmax_t strtoimax(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC strtoimax

EXTERN strtol

defc strtoimax = strtol

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoimax
defc _strtoimax = strtoimax
ENDIF

