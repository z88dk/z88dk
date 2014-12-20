
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


org __crt_org_code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION CODE

section code_crt_start
section code_crt_init
section code_crt_main
section code_crt_exit
section code_crt_return

include "../../clib_code.inc"
include "../../clib_rodata.inc"

section code_compiler
section rodata_compiler

section code_user
section rodata_user

SECTION CODE_END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_org_data != 0

   org __crt_org_data

ELSE

   IF __crt_model
   
      EXTERN ASMHEAD_CODE_END
      
      org ASMHEAD_CODE_END
   
   ENDIF

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION DATA

include "../../clib_smc.inc"
section smc_compiler
section smc_user

include "../../clib_data.inc"
section data_compiler
section data_user

SECTION DATA_END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __crt_org_bss != 0

   org __crt_org_bss

ELSE

   IF __crt_model
   
      EXTERN ASMHEAD_DATA_END
      
      org ASMHEAD_DATA_END

   ENDIF

ENDIF

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION BSS

include "../../clib_bss.inc"
section bss_compiler
section bss_user

SECTION BSS_END


;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
