;------------------------------------------------------------------------------
;       APU_OP_LD
;
;       DE = POINTER to OPERAND
;       A = APU COMMAND

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC _am9511a_op_ld    

    EXTERN APUCMDInPtr, APUPTRInPtr
    EXTERN APUCMDBufUsed, APUPTRBufUsed

    _am9511a_op_ld:
        push hl                 ; store HL so we don't clobber it
        ld l, a                 ; store COMMAND so we don't clobber it

        ld a, (APUCMDBufUsed)   ; Get the number of bytes in the COMMAND buffer
        cp __APU_CMD_SIZE-1     ; check whether there is space in the buffer
        jr nc, am9511a_operand_exit ; COMMAND buffer full, so exit

        ld a, l                 ; recover the operand entry COMMAND
        ld hl, (APUCMDInPtr)    ; get the pointer to where we poke
        ld (hl), a              ; write the COMMAND byte to the APUCMDInPtr   

        inc l                   ; move the COMMAND pointer low byte along, 0xFF rollover
        ld (APUCMDInPtr), hl    ; write where the next byte should be poked

        ld hl, APUCMDBufUsed
        inc (hl)                ; atomic increment of COMMAND count

        ld a, (APUPTRBufUsed)   ; Get the number of bytes in the OPERAND PTR buffer
        cp __APU_PTR_SIZE-2     ; check whether there is space for a OPERAND PTR
        jr nc, am9511a_operand_exit ; buffer full, so exit

        ld hl, (APUPTRInPtr)    ; get the pointer to where we poke
        ld (hl), e              ; write the low byte of OPERAND PTR to the APUPTRInPtr   
        inc l                   ; move the POINTER low byte along, 0xFF rollover
        ld (hl), d              ; write the high byte of OPERAND PTR to the APUPTRInPtr   
        inc l
        ld (APUPTRInPtr), hl    ; write where the next POINTER should be poked

        ld hl, APUPTRBufUsed
        inc (hl)                ; increment of OPERAND PTR count
        inc (hl)

    am9511a_operand_exit:
        pop hl                  ; recover HL
        ret
