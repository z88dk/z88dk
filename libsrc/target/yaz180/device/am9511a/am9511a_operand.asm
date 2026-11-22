;------------------------------------------------------------------------------
;       APU_OPP
;
;       OPERAND BANK in B
;       POINTER to OPERAND in DE
;       APU COMMAND in C

    INCLUDE "config_private.inc"

    SECTION code_driver

    PUBLIC asm_am9511a_opp

    EXTERN APUCMDInPtr, APUPTRInPtr
    EXTERN APUCMDBufUsed, APUPTRBufUsed

    asm_am9511a_opp:
        ld a,(APUCMDBufUsed)    ; Get the number of bytes in the COMMAND buffer
        cp __APU_CMD_SIZE-1     ; check whether there is space in the buffer
        ret NC                  ; COMMAND buffer full, so exit

        ld a,(APUPTRBufUsed)    ; Get the number of bytes in the OPERAND PTR buffer
        cp __APU_PTR_SIZE-4     ; check whether there is space for a 3 byte OPERAND PTR
        ret NC                  ; OPERAND POINTER buffer full, so exit

        in0 a,(BBR)             ; get the origin (this) bank
        rrca                    ; move the origin bank to low nibble
        rrca                    ; we know BBR lower nibble is 0
        rrca
        rrca
        add a,b                 ; create destination far address, from twos complement relative input
        and a,$0F               ; convert it to 4 bit address (not implicit here)

        rlca                    ; move the origin bank to high nibble
        rlca                    ; we know BBR lower nibble is 0
        rlca
        rlca
        ld b,a                  ; hold destination BBR in B

        di
        ld hl,(APUCMDInPtr)     ; get the pointer to where we poke
        ld (hl),c               ; write the COMMAND byte to the APUCMDInPtr
        inc l                   ; move the COMMAND pointer low byte along, 0xFF rollover
        ld (APUCMDInPtr),hl     ; write where the next byte should be poked

        ld hl,APUCMDBufUsed
        inc (hl)                ; atomic increment of COMMAND count
        

        ld hl,(APUPTRInPtr)     ; get the pointer to where we poke
        ld (hl),e               ; write the low byte of OPERAND PTR to the APUPTRInPtr
        inc l                   ; move the POINTER low byte along, 0xFF rollover
        ld (hl),d               ; write the high byte of OPERAND PTR to the APUPTRInPtr
        inc l
        ld (hl),b               ; write the BBR of OPERAND PTR to the APUPTRInPtr
        inc l
        ld (APUPTRInPtr),hl     ; write where the next POINTER should be poked

        ld hl,APUPTRBufUsed
        inc (hl)                ; increment of OPERAND PTR count
        inc (hl)
        inc (hl)

        ei
        ret                     ; just complete, and exit

