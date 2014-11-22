
INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION seg_code_error
   
   PUBLIC error_edom_mc
   
   EXTERN __EDOM, errno_mc
   
      pop hl
   
   error_edom_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EDOM
      
      ld l,__EDOM
      jp errno_mc
   
   
   SECTION seg_rodata_error_strings
   
   defb __EDOM
   defm "EDOM - Math argument out of domain"
   defb 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION seg_code_error
   
   PUBLIC error_edom_mc
   
   EXTERN errno_mc
   
   defc error_edom_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
