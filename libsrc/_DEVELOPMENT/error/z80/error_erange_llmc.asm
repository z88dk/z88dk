
SECTION code_clib
SECTION code_error

PUBLIC error_erange_llmc

EXTERN error_erange_lmc, error_lmc

   pop hl

error_erange_llmc:

   ; set dehl'dehl = -1
   ; set errno = ERANGE
   ; set carry flag
   
   exx
   call error_erange_lmc
   exx
   jp error_lmc
