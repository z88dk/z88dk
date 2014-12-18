
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SECTION CODE

org __crt_org_code

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

SECTION DATA

IF __crt_org_data != 0

   org __crt_org_data

ENDIF

include "../../clib_smc.inc"
section smc_compiler
section smc_user

include "../../clib_data.inc"
section data_compiler
section data_user

SECTION BSS

IF __crt_org_bss != 0

   org __crt_org_bss

ENDIF

include "../../clib_bss.inc"
section bss_compiler
section bss_user

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
