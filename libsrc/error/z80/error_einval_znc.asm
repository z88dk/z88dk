
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_einval_znc
   
   EXTERN error_einval_mc
   
      pop hl
   
   error_einval_znc:
   
      ; set hl = 0
      ; set carry flag
      ; set errno = EINVAL
      
      call error_einval_mc
      
      inc hl
      ccf
      ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_einval_znc
   
   EXTERN errno_znc
   
   defc error_einval_znc = errno_znc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
