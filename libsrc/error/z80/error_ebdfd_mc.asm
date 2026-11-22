
INCLUDE "config_private.inc"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_ebdfd_mc
   
   EXTERN __EBDFD, errno_mc
   
      pop hl
      pop hl
   
   error_ebdfd_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EBDFD
      
      ld l,__EBDFD
      jp errno_mc
   
   
   SECTION rodata_clib
   SECTION rodata_error_strings

   IF __CLIB_OPT_ERROR & $02

      defb __EBDFD
      defm "EBDFD - Bad file descriptor"
      defb 0

   ELSE
   
      defb __EBDFD
      defm "EBDFD"
      defb 0
   
   ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION code_clib
   SECTION code_error
   
   PUBLIC error_ebdfd_mc
   
   EXTERN errno_mc
   
   defc error_ebdfd_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
