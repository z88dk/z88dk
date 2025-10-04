;------------------------------------------------------------------------------  
;       Initialises the APU buffers
;
    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC asm_am9511a_reset

    EXTERN APUCMDBuf, APUPTRBuf
    EXTERN APUCMDInPtr, APUCMDOutPtr, APUPTRInPtr, APUPTROutPtr
    EXTERN APUCMDBufUsed, APUPTRBufUsed, APUStatus, APUError

    asm_am9511a_reset:
        push af
        push bc
        push de
        push hl

        ld  hl,APUCMDBuf        ; Initialise COMMAND Buffer
        ld (APUCMDInPtr),hl
        ld (APUCMDOutPtr),hl

        ld hl,APUPTRBuf         ; Initialise OPERAND POINTER Buffer
        ld (APUPTRInPtr),hl
        ld (APUPTROutPtr),hl

        xor a                   ; clear A register to 0

        ld (APUCMDBufUsed),a    ; 0 both Buffer counts
        ld (APUPTRBufUsed),a

        ld (APUCMDBuf),a        ; clear COMMAND Buffer
        ld hl,APUCMDBuf
        ld d,h
        ld e,l
        inc de
        ld bc,__APU_CMD_SIZE-1
        ldir

        ld (APUPTRBuf),a        ; clear OPERAND POINTER Buffer
        ld hl,APUPTRBuf
        ld d,h
        ld e,l
        inc de
        ld bc,__APU_PTR_SIZE-1
        ldir

        ld (APUStatus),a        ; set APU status to idle (NOP)
        ld (APUError),a         ; clear APU errors

    am9511a_reset_loop:
        ld bc,__IO_APU_STATUS  ; the address of the APU status port in bc
        in a,(c)               ; read the APU
        and __IO_APU_STATUS_BUSY    ; busy?
        jr NZ,am9511a_reset_loop

        pop hl
        pop de
        pop bc
        pop af
        ret
