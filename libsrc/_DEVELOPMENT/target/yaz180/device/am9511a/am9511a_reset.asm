;------------------------------------------------------------------------------  
;       Initialises the APU buffers
;
;       HL = address of the jump table nmi address

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC _am9511a_reset

    EXTERN _am9511a_isr

    EXTERN APUCMDBuf, APUPTRBuf
    EXTERN APUCMDInPtr, APUCMDOutPtr, APUPTRInPtr, APUPTROutPtr
    EXTERN APUCMDBufUsed, APUPTRBufUsed, APUStatus, APUError

    _am9511a_reset:
        push af
        push bc
        push de
        push hl

        LD  HL, APUCMDBuf       ; Initialise COMMAND Buffer
        LD (APUCMDInPtr), HL
        LD (APUCMDOutPtr), HL

        LD HL, APUPTRBuf        ; Initialise OPERAND POINTER Buffer
        LD (APUPTRInPtr), HL
        LD (APUPTROutPtr), HL

        XOR A                   ; clear A register to 0

        LD (APUCMDBufUsed), A   ; 0 both Buffer counts
        LD (APUPTRBufUsed), A

        LD (APUCMDBuf), A       ; clear COMMAND Buffer
        LD HL, APUCMDBuf
        LD D, H
        LD E, L
        INC DE
        LD BC, __APU_CMD_SIZE
        LDIR

        LD (APUPTRBuf), A       ; clear OPERAND POINTER Buffer
        LD HL, APUPTRBuf
        LD D, H
        LD E, L
        INC DE
        LD BC, __APU_PTR_SIZE
        LDIR

        ld (APUStatus), a       ; set APU status to idle (NOP)
        ld (APUError), a        ; clear APU errors

        pop hl                  ; load the jump table nmi address
        ld de, _am9511a_isr     ; load our interrupt origin
                                ; initially there is a RETN there
        ld (hl), e              ; load the address of the APU NMI jump
        inc hl
        ld (hl), d

    am9511a_reset_loop:
        ld bc, __IO_APU_PORT_STATUS ; the address of the APU status port in bc
        in a, (c)               ; read the APU
        and __IO_APU_STATUS_BUSY    ; busy?
        jr nz, am9511a_reset_loop

        pop de
        pop bc
        pop af
        ret
