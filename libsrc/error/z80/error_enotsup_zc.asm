
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_enotsup_zc
   
   EXTERN error_enotsup_mc
   
      pop hl
   
   error_enotsup_zc:
   
      ; set hl = 0
      ; set carry flag
      ; set errno = ENOTSUP
      
      call error_enotsup_mc
      
      inc hl
      ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_enotsup_zc
   
   EXTERN errno_zc
   
   defc error_enotsup_zc = errno_zc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
