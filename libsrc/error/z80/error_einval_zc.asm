
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_einval_zc
   
   EXTERN error_einval_mc
   
      pop hl
      pop hl
      pop hl
   
   error_einval_zc:
   
      ; set hl = 0
      ; set carry flag
      ; set errno = EINVAL
      
      call error_einval_mc
      
      inc hl
      ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_einval_zc
   
   EXTERN errno_zc
   
   defc error_einval_zc = errno_zc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
