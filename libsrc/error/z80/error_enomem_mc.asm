
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_enomem_mc
   
   EXTERN __ENOMEM, errno_mc
   
      pop hl
   
   error_enomem_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = ENOMEM
      
      ld l,__ENOMEM
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __ENOMEM
      defm "ENOMEM - Insufficient memory"
      defb 0

   ELSE
   
      defb __ENOMEM
      defm "ENOMEM"
      defb 0
   
   ENDIF
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_enomem_mc
   
   EXTERN errno_mc
   
   defc error_enomem_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
