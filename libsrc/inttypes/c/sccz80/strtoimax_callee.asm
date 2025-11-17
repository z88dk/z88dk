
; intmax_t strtoimax(const char *nptr, char **endptr, int base)

SECTION code_clib
SECTION code_inttypes

PUBLIC strtoimax_callee

EXTERN strtol_callee

defc strtoimax_callee = strtol_callee

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _strtoimax_callee
defc _strtoimax_callee = strtoimax_callee
ENDIF

