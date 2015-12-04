
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

   section code_driver
   section code_font
   section code_clib
   section code_lib
   section code_compiler
   section code_user

   section rodata_driver
   section rodata_font
   section rodata_clib
   section rodata_error_strings
   section rodata_error_string_end
   defb 0
   section rodata_lib
   section rodata_compiler
   section rodata_user

   section smc_driver
   section smc_font
   section smc_clib
   section smc_lib
   section smc_compiler
   section smc_user

   section data_driver
   section data_font
   section data_clib
   section data_fcntl_stdio_heap_head
   section data_fcntl_stdio_heap_body
   section data_fcntl_stdio_heap_tail
   section data_fcntl_fdtable_body
   section data_lib
   section data_compiler
   section data_user

   section BSS_UNINITIALIZED
   section bss_driver
   section bss_font
   section bss_clib
   section bss_lib
   section bss_compiler
   section bss_user

   SECTION AREA_CODE_END

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   SECTION AREA_DATA
   defb 0
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
