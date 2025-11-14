
SECTION code_clib
SECTION code_error

PUBLIC error_mulu_overflow_mc

EXTERN error_erange_mc

; unsigned multiply overflow occurred
; default behaviour is to note error in errno and carry on

defc error_mulu_overflow_mc = error_erange_mc
