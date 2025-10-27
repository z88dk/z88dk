
SECTION code_clib
SECTION code_error

PUBLIC error_divide_by_zero_mc

EXTERN error_edom_mc

; integer divide by zero occurred
; default behaviour is to note error in errno and carry on

defc error_divide_by_zero_mc = error_edom_mc
