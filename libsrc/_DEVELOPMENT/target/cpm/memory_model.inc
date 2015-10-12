
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

IF __MMAP = -1

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; user supplied memory map ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   INCLUDE "mmap.inc"

ENDIF

IF __MMAP = 0

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;; standard CODE/DATA/BSS memory map ;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION CODE

   org __crt_org_code

   section code_crt_init
   section code_crt_main
   section code_crt_exit
   section code_crt_return
   section code_crt_common

   include "../../clib_code.inc"
   include "../../clib_rodata.inc"

   section code_lib
   section rodata_lib

   section code_compiler
   section rodata_compiler

   section code_user
   section rodata_user

   SECTION CODE_END

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION DATA

   IF __crt_org_data

      org __crt_org_data

   ELSE

      IF __crt_model
      
         "DATA section address must be specified for rom models"
   
      ENDIF

   ENDIF

   defb 0

   include "../../clib_smc.inc"
   section smc_compiler
   section smc_lib
   section smc_user

   include "../../clib_data.inc"
   section data_compiler
   section data_lib
   section data_user

   SECTION DATA_END

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION BSS

   IF __crt_org_bss

      org __crt_org_bss

   ELSE

      IF __crt_model

         org -1

      ENDIF

   ENDIF

   defb 0

   section BSS_UNINITIALIZED
   include "../../clib_bss.inc"
   section bss_compiler
   section bss_lib
   section bss_user

   SECTION BSS_END

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
