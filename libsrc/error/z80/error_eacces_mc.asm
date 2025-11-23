
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_eacces_mc
   
   EXTERN __EACCES, errno_mc
   
      pop hl
   
   error_eacces_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EACCES
      
      ld l,__EACCES
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings
   
   IF __CLIB_OPT_ERROR & $02
   
      defb __EACCES
      defm "EACCES - Permission denied"
      defb 0

   ELSE
   
      defb __EACCES
      defm "EACCES"
      defb 0
   
   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_eacces_mc
   
   EXTERN errno_mc
   
   defc error_eacces_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
