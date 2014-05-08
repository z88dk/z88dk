
PUBLIC error_mulu_overflow_mc

EXTERN error_erange_mc

error_mulu_overflow_mc:

   jp error_erange_mc

;defc error_mulu_overflow_mc = error_erange_mc

   ; unsigned multiply overflow occurred
   ;
   ; default behaviour is to carry on and
   ; record error in errno
