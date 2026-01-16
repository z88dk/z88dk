
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_eoverflow_mc
   
   EXTERN __EOVERFLOW, errno_mc
   
      pop hl
   
   error_eoverflow_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EOVERFLOW
      
      ld l,__EOVERFLOW
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __EOVERFLOW
      defm "EOVERFLOW - Value too large for data type"
      defb 0

   ELSE
   
      defb __EOVERFLOW
      defm "EOVERFLOW"
      defb 0
   
   ENDIF
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_eoverflow_mc
   
   EXTERN errno_mc
   
   defc error_eoverflow_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
