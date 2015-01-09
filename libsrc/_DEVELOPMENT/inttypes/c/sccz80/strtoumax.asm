
; uintmax_t strtoumax(const char *nptr, char **endptr, int base)

SECTION code_inttypes

PUBLIC strtoumax

EXTERN strtoul

defc strtoumax = strtoul
