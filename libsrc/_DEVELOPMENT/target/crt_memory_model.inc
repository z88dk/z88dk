
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

include "code_clib.inc"
include "rodata_clib.inc"

section code_compiler
section rodata_compiler

section code_user
section rodata_user

SECTION DATA

IF __crt_org_data != 0

   org __crt_org_data

ENDIF

include "smc_clib.inc"
section smc_compiler
section smc_user

include "data_clib.inc"
section data_compiler
section data_user

SECTION BSS

IF __crt_org_bss != 0

   org __crt_org_bss

ENDIF

include "bss_clib.inc"
section bss_compiler
section bss_user

;; end memory model ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
