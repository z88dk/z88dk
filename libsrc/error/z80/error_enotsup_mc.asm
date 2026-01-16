
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_enotsup_mc
   
   EXTERN __ENOTSUP, errno_mc
   
      pop hl
   
   error_enotsup_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = ENOTSUP
      
      ld l,__ENOTSUP
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __ENOTSUP
      defm "ENOTSUP - Not supported"
      defb 0

   ELSE
   
      defb __ENOTSUP
      defm "ENOTSUP"
      defb 0
   
   ENDIF
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_enotsup_mc
   
   EXTERN errno_mc
   
   defc error_enotsup_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
