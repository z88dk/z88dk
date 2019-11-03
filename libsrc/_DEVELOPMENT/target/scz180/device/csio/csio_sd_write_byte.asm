
INCLUDE "config_private.inc"

SECTION code_driver

EXTERN l_reverse

PUBLIC sd_write_byte

    ;Do a write bus cycle to the SD drive, via the CSIO
    ;
    ;input A = byte to write to SD drive
    
.sd_write_byte
    ld a,l
    call l_reverse          ;reverse the bits before we busy wait
.sd_write_wait
    in0 a,(CNTR)
    tst CNTR_TE|CNTR_RE     ;check the SD is not enabled
    jr NZ,sd_write_wait

    out0 (TRDR),l           ;load (reversed) byte to transmit
    or a,CNTR_TE
    out0 (CNTR),a           ;enable transmit
    ret
