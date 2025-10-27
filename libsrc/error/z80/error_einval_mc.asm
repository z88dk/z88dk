
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_einval_mc
   
   EXTERN __EINVAL, errno_mc
   
      pop hl
   
   error_einval_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EINVAL
      
      ld l,__EINVAL
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __EINVAL
      defm "EINVAL - Invalid argument"
      defb 0

   ELSE
   
      defb __EINVAL
      defm "EINVAL"
      defb 0
   
   ENDIF
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_einval_mc
   
   EXTERN errno_mc
   
   defc error_einval_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
