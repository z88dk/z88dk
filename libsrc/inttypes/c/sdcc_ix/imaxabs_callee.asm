
; intmax_t imaxabs(intmax_t j)

SECTION code_clib
SECTION code_inttypes

PUBLIC _imaxabs_callee

EXTERN _llabs_callee

defc _imaxabs_callee = _llabs_callee
