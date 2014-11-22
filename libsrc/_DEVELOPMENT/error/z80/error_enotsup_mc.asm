
INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION seg_code_error
   
   PUBLIC error_enotsup_mc
   
   EXTERN __ENOTSUP, errno_mc
   
      pop hl
   
   error_enotsup_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = ENOTSUP
      
      ld l,__ENOTSUP
      jp errno_mc
   
   
   SECTION seg_rodata_error_strings
   
   defb __ENOTSUP
   defm "ENOTSUP - Not supported"
   defb 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION seg_code_error
   
   PUBLIC error_enotsup_mc
   
   EXTERN errno_mc
   
   defc error_enotsup_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
