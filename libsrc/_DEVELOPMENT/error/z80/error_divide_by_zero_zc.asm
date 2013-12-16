
XLIB error_divide_by_zero_zc
LIB error_edom_zc

error_divide_by_zero_zc:

   ; integer divide by zero occurred
   ;
   ; default behaviour is to carry on and
   ; record error in errno
   
   jp error_edom_zc
