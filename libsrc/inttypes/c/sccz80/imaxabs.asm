
; intmax_t imaxabs(intmax_t j)

SECTION code_clib
SECTION code_inttypes

PUBLIC imaxabs

EXTERN labs

defc imaxabs = labs

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _imaxabs
defc _imaxabs = imaxabs
ENDIF

