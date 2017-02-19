
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_ebadf_mc
   
   EXTERN __EBADF, errno_mc
   
      pop hl
   
   error_ebadf_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EBADF
      
      ld l,__EBADF
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __EBADF
      defm "EBADF - Invalid stream"
      defb 0

   ELSE
   
      defb __EBADF
      defm "EBADF"
      defb 0
   
   ENDIF
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_ebadf_mc
   
   EXTERN errno_mc
   
   defc error_ebadf_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
