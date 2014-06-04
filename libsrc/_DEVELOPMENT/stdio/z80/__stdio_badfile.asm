
PUBLIC __stdio_badfile

EXTERN error_ebadf_zc

__stdio_badfile:

   ; a minimum FILE structure that returns errors
   
   defb 195
   defw error_ebadf_zc
   defb 0,0,0,0
   defb 0,0
