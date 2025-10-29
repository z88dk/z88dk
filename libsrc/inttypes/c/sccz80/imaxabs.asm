
; intmax_t imaxabs(intmax_t j)

SECTION code_clib
SECTION code_inttypes

PUBLIC imaxabs

EXTERN labs

defc imaxabs = labs
