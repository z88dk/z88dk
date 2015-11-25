
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
   ;; standard symbos memory map ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION AREA_HEADER
   org 0
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   SECTION AREA_CODE

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

   include "../../clib_smc.inc"
   section smc_compiler
   section smc_lib
   section smc_user

   include "../../clib_data.inc"
   section data_compiler
   section data_lib
   section data_user

   section BSS_UNINITIALIZED
   include "../../clib_bss.inc"
   section bss_compiler
   section bss_lib
   section bss_user

   SECTION AREA_CODE_END

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION AREA_DATA
   SECTION AREA_DATA_END
   
   SECTION AREA_TRANSFER
   SECTION AREA_TRANSFER_END

   SECTION AREA_CODE_RESERVED
   org 0
   SECTION AREA_CODE_RESERVED_END
   
   SECTION AREA_DATA_RESERVED
   org 0
   SECTION AREA_DATA_RESERVED_END
   
   SECTION AREA_TRANSFER_RESERVED
   org 0
   SECTION AREA_TRANSFER_RESERVED_END
   
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
ENDIF

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
