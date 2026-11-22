
; intmax_t imaxabs_fastcall(intmax_t j)

SECTION code_clib
SECTION code_inttypes

PUBLIC _imaxabs_fastcall

EXTERN _labs_fastcall

defc _imaxabs_fastcall = _labs_fastcall
