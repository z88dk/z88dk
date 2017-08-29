;------------------------------------------------------------------------------
;       APU_CMD_LD
;
;       A = APU COMMAND

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC _am9511a_cmd_ld    

    EXTERN APUCMDInPtr, APUPTRInPtr
    EXTERN APUCMDBufUsed, APUPTRBufUsed

    _am9511a_cmd_ld:
        push hl                 ; store HL so we don't clobber it
        ld l, a                 ; store COMMAND so we don't clobber it

        ld a, (APUCMDBufUsed)   ; Get the number of bytes in the COMMAND buffer
        cp __APU_CMD_SIZE-1     ; check whether there is space in the buffer
        jr nc, am9511a_command_exit ; COMMAND buffer full, so exit

        ld a, l                 ; recover the operand entry COMMAND
        ld hl, (APUCMDInPtr)    ; get the pointer to where we poke
        ld (hl), a              ; write the COMMAND byte to the APUCMDInPtr   

        inc l                   ; move the COMMAND pointer low byte along, 0xFF rollover
        ld (APUCMDInPtr), hl    ; write where the next byte should be poked

        ld hl, APUCMDBufUsed
        inc (hl)                ; atomic increment of COMMAND count

    am9511a_command_exit:
        pop hl                  ; recover HL
        ret
