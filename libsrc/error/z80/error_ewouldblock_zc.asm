
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_ewouldblock_zc
   
   EXTERN __EWOULDBLOCK, errno_zc
   
      pop hl
   
   error_ewouldblock_zc:
   
      ; set hl = 0
      ; set carry flag
      ; set errno = EWOULDBLOCK
      
      ld l,__EWOULDBLOCK
      jp errno_zc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __EWOULDBLOCK
      defm "EWOULDBLOCK - Operation would block"
      defb 0

   ELSE
   
      defb __EWOULDBLOCK
      defm "EWOULDBLOCK"
      defb 0
   
   ENDIF
   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_ewouldblock_zc
   
   EXTERN errno_zc
   
   defc error_ewouldblock_zc = errno_zc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
