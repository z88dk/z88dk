
INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION seg_code_error
   
   PUBLIC error_einval_mc
   
   EXTERN __EINVAL, errno_mc
   
      pop hl
   
   error_einval_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EINVAL
      
      ld l,__EINVAL
      jp errno_mc
   
   
   SECTION seg_rodata_error_strings
   
   defb __EINVAL
   defm "EINVAL - Invalid argument"
   defb 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION seg_code_error
   
   PUBLIC error_einval_mc
   
   EXTERN errno_mc
   
   defc error_einval_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
