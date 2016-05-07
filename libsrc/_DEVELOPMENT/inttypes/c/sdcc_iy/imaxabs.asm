
; intmax_t imaxabs(intmax_t j)

SECTION code_clib
SECTION code_inttypes

PUBLIC _imaxabs

EXTERN _llabs

defc _imaxabs = _llabs
