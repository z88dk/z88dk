;; BLACK STAR CUSTOM MEMORY MAP
;; This file will replace the crt's memory map.
;; This is done via pragma in file "zpragma.inc".
;;
;; This custom memory map creates sections to hold items
;; destined for contended memory.  It is based on a simple
;; modification of the default memory map defined by z88dk in:
;; 
;; z88dk/libsrc/_DEVELOPMENT/target/crt_memory_model.inc

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; closer to the beginning is lower in memory which
; means more likely to be in contended memory

SECTION GAME
org __crt_org_code

EXTERN __Start
jp     __Start  ;; the first thing in the binary will be a jump to the crt

SECTION CONTENDED

;; fall into the standard memory map ;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION CODE

section code_crt_init
section code_crt_main
section code_crt_exit
section code_crt_return
section code_crt_common

section code_driver
section code_font
section code_clib
  include "../../clib_code.inc"
section code_lib
section code_compiler
section code_user

section rodata_driver
section rodata_font
section rodata_clib
  include "../../clib_rodata.inc"
  ;;section rodata_error_strings
  ;;section rodata_error_string_end
  ;;defb 0
section rodata_lib
section rodata_compiler
section rodata_user

SECTION CODE_END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION DATA

section smc_driver
section smc_font
section smc_clib
  include "../../clib_smc.inc"
section smc_lib
section smc_compiler
section smc_user

section data_driver
section data_font
section data_clib
  include "../../clib_data.inc"
  ;;section data_fcntl_stdio_heap_head
  ;;section data_fcntl_stdio_heap_body
  ;;section data_fcntl_stdio_heap_tail
  ;;section data_fcntl_fdtable_body
section data_lib
section data_compiler
section data_user

SECTION DATA_END

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION BSS

section BSS_UNINITIALIZED

section bss_driver
section bss_font
section bss_clib
  include "../../clib_bss.inc"
section bss_lib
section bss_compiler
section bss_user

SECTION BSS_END

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
