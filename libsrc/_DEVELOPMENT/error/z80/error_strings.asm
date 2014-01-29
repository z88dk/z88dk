
XLIB error_strings
XDEF error_string_default

error_strings:

   defb __EOK
   defm "EOK - No error"
   defb 0
   
   defb __EDOM
   defm "EDOM - Math argument out of domain"
   defb 0
   
   defb __EINVAL
   defm "EINVAL - Invalid argument"
   defb 0
   
   defb __ENOMEM
   defm "ENOMEM - Insufficient memory"
   defb 0
   
   defb __ERANGE
   defm "ERANGE - Result too large"
   defb 0
   
   defb __EACCES
   defm "EACCES - Permission denied"
   defb 0
   
   defb __ENOLCK
   defm "ENOLCK - Attempt to lock failed"
   defb 0
   
   defb __EOVERFLOW
   defm "EOVERFLOW - Value too large for data type"
   defb 0
   
   defb __ENOTSUP
   defm "ENOTSUP - Not supported"
   defb 0
   
   defb __EFBIG
   defm "EFBIG - File too large"
   defb 0
   
   defb __EBADF
   defm "EBADF - Invalid file"
   defb 0
   
   defb 0                      ; strings terminator

error_string_default:

   defb "EUNKWN - Unknown"
   defb 0
