
SECTION seg_code_fcntl

PUBLIC driver_error_enolck_zc

EXTERN error_enolck_zc

   pop hl

driver_error_enolck_zc:

   ; exit point for drivers that restores ix from stack

   pop ix
   jp error_enolck_zc
