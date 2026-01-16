
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_enomem_zc
   
   EXTERN error_enomem_mc
   
      pop hl
      pop hl
   
   error_enomem_zc:
   
      ; set hl = 0
      ; set carry flag
      ; set errno = ENOMEM
      
      call error_enomem_mc
      
      inc hl
      ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_enomem_zc
   
   EXTERN errno_zc
   
   defc error_enomem_zc = errno_zc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
