;------------------------------------------------------------------------------
;       APU_CMD
;
;       C = APU COMMAND

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC asm_am9511a_cmd

    EXTERN APUCMDInPtr, APUPTRInPtr
    EXTERN APUCMDBufUsed, APUPTRBufUsed


    asm_am9511a_cmd:
        ld a,(APUCMDBufUsed)        ; Get the number of bytes in the COMMAND buffer
        cp __APU_CMD_SIZE-1         ; check whether there is space in the buffer
        ret NC                      ; COMMAND buffer full, so exit

        ld hl,APUCMDBufUsed
        di
        inc (hl)                    ; atomic increment of COMMAND count    
        ld hl,(APUCMDInPtr)         ; get the pointer to where we poke
        ei
        ld (hl),c                   ; write the COMMAND byte to the APUCMDInPtr   

        inc l                       ; move the COMMAND pointer low byte along, 0xFF rollover
        ld (APUCMDInPtr),hl         ; write where the next byte should be poked
        ret

