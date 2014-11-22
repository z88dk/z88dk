
INCLUDE "clib_cfg.asm"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
IF __CLIB_OPT_ERROR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   ; verbose mode

   SECTION seg_code_error
   
   PUBLIC error_efbig_mc
   
   EXTERN __EFBIG, errno_mc
   
      pop hl
   
   error_efbig_mc:
   
      ; set hl = -1
      ; set carry flag
      ; set errno = EFBIG
      
      ld l,__EFBIG
      jp errno_mc
   
   
   SECTION seg_rodata_error_strings
   
   defb __EFBIG
   defm "EFBIG - File too large"
   defb 0


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ELSE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION seg_code_error
   
   PUBLIC error_efbig_mc
   
   EXTERN errno_mc
   
   defc error_efbig_mc = errno_mc - 2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ENDIF
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
