
INCLUDE "config_private.inc"

SECTION code_driver

EXTERN l_mirror 

PUBLIC asm_sd_write_byte

    ;Do a write bus cycle to the SD drive, via the CSIO
    ;
    ;input L = byte to write to SD drive
    
.asm_sd_write_byte
    ld a,l
    call l_mirror           ; reverse the bits before we busy wait
.sd_write_wait
    in0 a,(CNTR)
    tst CNTR_TE|CNTR_RE     ; check the CSIO is not enabled
    jr NZ,sd_write_wait

    or a,CNTR_TE            ; set TE bit
    out0 (TRDR),l           ; load (reversed) byte to transmit
    out0 (CNTR),a           ; enable transmit
    ret
