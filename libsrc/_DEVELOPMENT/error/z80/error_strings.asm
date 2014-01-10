
XLIB error_strings
XDEF error_string_default

error_strings:

   defb __EOK
   defm "EOK - No error"
   defb 0
   
   defb __EDOM
   defm "EDOM - Math function out of domain"
   defb 0
   
   defb __EINVAL
   defm "EINVAL - Invalid argument"
   defb 0
   
   defb __ENOMEM
   defm "ENOMEM - Insufficient memory"
   defb 0
   
   defb __ERANGE
   defm "ERANGE - Math result not representable"
   defb 0
   
   defb __EACCES
   defm "EACCES - Permission denied"
   defb 0
   
   defb __ENOLCK
   defm "ENOLCK - Attempt to lock failed"
   defb 0
   
   defb 0                      ; string terminator

error_string_default:

   defb "EUNKWN - Unknown"
   defb 0
