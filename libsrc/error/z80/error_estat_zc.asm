
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_estat_zc
   
   EXTERN __ESTAT, errno_zc
   
      pop hl
   
   error_estat_zc:
   
      ; set hl = 0
      ; set carry flag
      ; set errno = ESTAT
      
      ld l,__ESTAT
      jp errno_zc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __ESTAT
      defm "ESTAT - Unknown driver error"
      defb 0

   ELSE
   
      defb __ESTAT
      defm "ESTAT"
      defb 0
   
   ENDIF
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_estat_zc
   
   EXTERN errno_zc
   
   defc error_estat_zc = errno_zc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
