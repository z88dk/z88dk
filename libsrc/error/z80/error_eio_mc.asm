
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_eio_mc
   
   EXTERN __EIO, errno_mc
   
      pop hl
   
   error_eio_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EIO
      
      ld l,__EIO
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings
   
   IF __CLIB_OPT_ERROR & $02
   
      defb __EIO
      defm "EIO - I/O Error"
      defb 0

   ELSE
   
      defb __EIO
      defm "EIO"
      defb 0
   
   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_eio_mc
   
   EXTERN errno_mc
   
   defc error_eio_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
