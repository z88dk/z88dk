
SECTION code_clib
SECTION code_error

PUBLIC error_divide_by_zero_zc

EXTERN error_edom_zc

; integer divide by zero occurred
; default behaviour is to note error in errno and carry on

defc error_divide_by_zero_zc = error_edom_zc
