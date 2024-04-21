; Classic Memory map and section setup
;
; This layout suits all the classic machines. Memory placement is 
; affected by:
;
; CRT_MODEL: RAM/ROM configuration
; CRT_ORG_CODE: Where code starts executing from
; CRT_ORG_BSS:  Where uninitialised global variables are placed
; CRT_ORG_GRAPHICS: Where graphics routines + variables are stored (certain ports only)
; CRT_ORG_FAR: Where far routines + variables are stored (certain ports only)

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

; For ROM compilation, the data section has to sit in RAM. It's placed
; after the BSS section
IF __crt_model > 0
    SECTION DATA
    org     -1
    defb    0		; control name of data binary
    INCLUDE "crt/classic/crt_section_data.inc"
ENDIF
    SECTION BSS_END

; On some targets, the program sits in low memory AND the screen can
; only be accessed by paging it into low memory. To mitigate this
; routines that access the screen are placed in high memory. 
;
; We might have a similar issue with far code, so create a placeholder
; for that as well
IF __crt_org_graphics > 0 || __crt_org_far > 0
    SECTION	HIMEM
    SECTION code_himem
    SECTION rodata_himem
    SECTION data_himem
    SECTION bss_himem
IF __crt_org_graphics
    org	__crt_org_graphics
    SECTION smc_clib
    SECTION code_graphics
    SECTION rodata_graphics
    SECTION data_graphics
    SECTION bss_graphics
ELIF __crt_org_far
    SECTION code_far
    SECTION code_l_sccz80_far
    SECTION data_far
    SECTION rodata_far
    SECTION bss_far

    SECTION HIMEM_END
ENDIF
ENDIF
