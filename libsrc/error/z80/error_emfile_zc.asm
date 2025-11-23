
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_emfile_zc
   
   EXTERN __EMFILE, errno_zc
   
      pop hl
   
   error_emfile_zc:
   
      ; set hl = 0
      ; set carry flag
      ; set errno = EMFILE
      
      ld l,__EMFILE
      jp errno_zc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __EMFILE
      defm "EMFILE - Too many files"
      defb 0

   ELSE
   
      defb __EMFILE
      defm "EMFILE"
      defb 0
   
   ENDIF
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_emfile_zc
   
   EXTERN errno_zc
   
   defc error_emfile_zc = errno_zc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
