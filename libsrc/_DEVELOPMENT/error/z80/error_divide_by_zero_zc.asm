
PUBLIC error_divide_by_zero_zc

EXTERN error_edom_zc

error_divide_by_zero_zc:

   jp error_edom_zc

;defc error_divide_by_zero_zc = error_edom_zc

   ; integer divide by zero occurred
   ;
   ; default behaviour is to carry on and
   ; record error in errno
