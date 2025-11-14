
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_efbig_mc
   
   EXTERN __EFBIG, errno_mc
   
      pop hl
   
   error_efbig_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EFBIG
      
      ld l,__EFBIG
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __EFBIG
      defm "EFBIG - File too large"
      defb 0

   ELSE
   
      defb __EFBIG
      defm "EFBIG"
      defb 0
   
   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_efbig_mc
   
   EXTERN errno_mc
   
   defc error_efbig_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
