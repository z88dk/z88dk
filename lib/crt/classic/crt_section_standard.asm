; Classic Memory map and section setup
;
; This layout suits all the classic machines. Memory placement is 
; affected by:
;
; CRT_MODEL: RAM/ROM configuration
; CRT_ORG_CODE: Where code starts executing from
; CRT_ORG_BSS:  Where uninitialised global variables are placed
; CRT_ORG_GRAPHICS: Where graphics routines + variables are stored (certain ports only)

;
; Contains the generic variables + features

;
; crt_model = 0		; everything in RAM
; crt_model = 1		; ROM model, data section copied
; crt_model = 2		; ROM model, data section compressed (zx7)
; crt_model = 3		; ROM model, data section compressed (zx0)



    INCLUDE "crt/classic/crt_section_code.inc"
    INCLUDE "crt/classic/crt_section_rodata.inc"
    SECTION ROMABLE_END
IF !__crt_model
    INCLUDE "crt/classic/crt_section_data.inc"
ENDIF
    INCLUDE "crt/classic/crt_section_bss.inc"

IF __crt_model > 0
    SECTION DATA
    org     -1
    defb    0		; control name of data binary
    INCLUDE "crt/classic/crt_section_data.inc"
ENDIF
    SECTION BSS_END

IF __crt_org_graphics
    SECTION	HIMEM
    org	__crt_org_graphics
    SECTION smc_clib
    SECTION code_graphics
    SECTION code_himem
    SECTION rodata_graphics
    SECTION rodata_himem
    SECTION data_himem
    SECTION data_graphics
    SECTION bss_graphics
    SECTION bss_himem
    SECTION HIMEM_END
ENDIF
