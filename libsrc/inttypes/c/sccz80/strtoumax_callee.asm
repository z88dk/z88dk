
; uintmax_t strtoumax(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC strtoumax_callee

EXTERN strtoul_callee

defc strtoumax_callee = strtoul_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoumax_callee
defc _strtoumax_callee = strtoumax_callee
ENDIF

