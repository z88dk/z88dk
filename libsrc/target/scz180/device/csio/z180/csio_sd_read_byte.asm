
INCLUDE "config_private.inc"

SECTION code_driver

EXTERN l_mirror 

PUBLIC asm_sd_read_byte

    ;Do a read bus cycle to the SD drive, via the CSIO
    ;  
    ;output L = byte read from SD drive

.asm_sd_read_byte
    in0 a,(CNTR)
    tst CNTR_TE|CNTR_RE     ; check the CSIO is not enabled
    jr NZ,asm_sd_read_byte

    or a,CNTR_RE            ; set RE bit
    out0(CNTR),a            ; enable reception
.sd_read_wait
    in0 a,(CNTR)
    tst CNTR_RE             ; check the read has completed
    jr NZ,sd_read_wait

    in0 a,(TRDR)            ; read byte
    jp l_mirror             ; reverse the byte, leave in L and A
