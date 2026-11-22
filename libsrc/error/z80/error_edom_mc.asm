
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_edom_mc
   
   EXTERN __EDOM, errno_mc
   
      pop hl
   
   error_edom_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EDOM
      
      ld l,__EDOM
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __EDOM
      defm "EDOM - Math argument out of domain"
      defb 0

   ELSE
   
      defb __EDOM
      defm "EDOM"
      defb 0
   
   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_edom_mc
   
   EXTERN errno_mc
   
   defc error_edom_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
