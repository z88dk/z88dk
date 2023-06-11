; Small snippet to either set the screenmode, or read the current
; one and set the library up to use that screenmode

    EXTERN  asm_sam_set_screenmode
IF CLIB_DEFAULT_SCREEN_MODE = -1
    in      a,(VMPR)
    rlca
    rlca
    rlca
    and     @00000011
    inc     a
ELSE
    ld      a,CLIB_DEFAULT_SCREEN_MODE
ENDIF
    call    asm_sam_set_screenmode
