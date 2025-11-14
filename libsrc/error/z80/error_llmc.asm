
SECTION code_clib
SECTION code_error

PUBLIC error_llmc

EXTERN error_lmc

   pop hl

error_llmc:

   ; set dehl'dehl = -1
   ; set carry flag

   exx
   call error_lmc
   exx
   jp error_lmc
