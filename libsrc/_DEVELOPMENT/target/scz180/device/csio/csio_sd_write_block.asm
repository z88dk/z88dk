
INCLUDE "config_private.inc"

SECTION code_driver

EXTERN l_reverse

PUBLIC _sd_write_block

    ;Write a block of 512 bytes (one sector) from (HL++) to the drive
    ;
    ;input HL = pointer to block to write
    ;uses AF, BC, DE, HL

._sd_write_block
    in0 a,(CNTR)
    tst CNTR_TE|CNTR_RE     ;check the SD is not enabled
    jr NZ,_sd_write_block

    and ~CNTR_RE            ; mask off RE bit
    or CNTR_TE              ; set TE bit

    ex de,hl                ; pointer in DE
    ld bc,CNTR              ; keep iterative word count in B, and C has CNTR IO port address
    ld h,a                  ; H now contains CNTR bits to start transmission

.sd_write_nextword
    ld a,(de)               ; upper byte
    call l_reverse          ; reversed bits in A and L
.sd_write_wait_h
    tstio CNTR_TE           ; test bits in IO port (C)
    jr NZ,sd_write_wait_h   ; wait for transmit to complete

    out0 (TRDR),l           ; write byte to transmit
    out0 (CNTR),h           ; start transmit

    inc de                  ; ptr++
    ld a,(de)               ; lower byte
    call l_reverse          ; reversed bits in A and L
.sd_write_wait_l
    tstio CNTR_TE           ; test bits in IO port (C)
    jr NZ,sd_write_wait_l   ; wait for transmit to complete

    out0 (TRDR),l           ; write byte to transmit
    out0 (CNTR),h           ; start transmit

    inc de                  ; ptr++
    djnz sd_write_nextword  ; length != 0, go again
    ret
