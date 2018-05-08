;------------------------------------------------------------------------------
;       APU_CMD_LD
;
;       DE = POINTER to OPERAND, IF REQUIRED
;       A = APU COMMAND

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC asm_am9511a_cmd_ld    

    EXTERN APUCMDInPtr, APUPTRInPtr
    EXTERN APUCMDBufUsed, APUPTRBufUsed

    asm_am9511a_cmd_ld:
        push hl                 ; store HL so we don't clobber it
        ld l,a                  ; store COMMAND so we don't clobber it

        ld a,(APUCMDBufUsed)    ; Get the number of bytes in the COMMAND buffer
        cp __APU_CMD_SIZE-1     ; check whether there is space in the buffer
        jr NC,am9511a_command_exit ; COMMAND buffer full, so exit
        
        ld a,(APUPTRBufUsed)    ; Get the number of bytes in the OPERAND PTR buffer
        cp __APU_PTR_SIZE-2     ; check whether there is space for a OPERAND PTR
        jr NC,am9511a_command_exit ; OPERAND buffer full, so exit

        ld hl,APUCMDBufUsed
        di
        inc (hl)                ; atomic increment of COMMAND count
        ld a,l                  ; recover the COMMAND
        ld hl,(APUCMDInPtr)     ; get the pointer to where we poke
        ei
        ld (hl),a               ; write the COMMAND byte to the APUCMDInPtr   

        inc l                   ; move the COMMAND pointer low byte along, 0xFF rollover
        ld (APUCMDInPtr),hl     ; write where the next byte should be poked

        and $F0                 ; mask only most significant nibble of COMMAND
        cp __IO_APU_OP_ENT      ; check whether it is OPERAND entry COMMAND
        jr Z,am9511a_cmd_op     ; load an OPERAND pointer
        cp __IO_APU_OP_REM      ; check whether it is OPERAND removal COMMAND
        jr Z,am9511a_cmd_op     ; load an OPERAND pointer

    am9511a_command_exit:
        pop hl                  ; recover HL
        ret

    am9511a_cmd_op:
        ld hl,APUPTRBufUsed
        di
        inc (hl)                ; increment of OPERAND PTR count
        inc (hl)    
        ld hl,(APUPTRInPtr)     ; get the pointer to where we poke
        ld (hl),e               ; write the low byte of OPERAND PTR to the APUPTRInPtr   
        inc l                   ; move the POINTER low byte along, 0xFF rollover
        ld (hl),d               ; write the high byte of OPERAND PTR to the APUPTRInPtr   
        inc l
        ei
        ld (APUPTRInPtr),hl     ; write where the next POINTER should be poked

        jr am9511a_command_exit

