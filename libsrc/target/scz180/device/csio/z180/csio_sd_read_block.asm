
INCLUDE "config_private.inc"

SECTION code_driver

EXTERN l_mirror 

PUBLIC asm_sd_read_block

    ;Read a block of 512 bytes (one sector) from the drive
    ;and store it in memory at (HL++)
    ;
    ;input HL = pointer to block
    ;uses AF, BC, DE, HL

.asm_sd_read_block
    in0 a,(CNTR)
    tst CNTR_TE|CNTR_RE     ;check the CSIO is not enabled
    jr NZ,asm_sd_read_block

    or CNTR_RE              ; set RE bit
    out0 (CNTR),a           ; start receiving first byte

    ex de,hl                ; pointer in DE
    ld bc,CNTR              ; keep iterative word count in B, and C has CNTR IO port address
    ld h,a                  ; H now contains CNTR bits to start reception

    jr sd_read_wait         ; get first byte

.sd_read_again
    out0 (CNTR),h           ; start receiving next byte

    call l_mirror           ; reversed bits in A and L
    ld (de),a               ; upper byte
    inc de                  ; ptr++

.sd_read_wait
    tstio CNTR_RE           ; test bits in IO port (C)
    jr NZ,sd_read_wait      ; wait for reception to complete

    in0 a,(TRDR)            ; read byte
    out0 (CNTR),h           ; start reception next byte
    call l_mirror           ; reversed bits in A and L
    ld (de),a               ; lower byte
    inc de                  ; ptr++

.sd_read_wait_h
    tstio CNTR_RE           ; test bits in IO port (C)
    jr NZ,sd_read_wait_h    ; wait for reception to complete

    in0 a,(TRDR)            ; read byte
    djnz sd_read_again      ; length != 0, go again

    call l_mirror           ; reversed bits in A and L
    ld (de),a               ; upper byte
    ret
