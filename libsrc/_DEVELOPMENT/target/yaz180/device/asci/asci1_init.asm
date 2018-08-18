
    INCLUDE "config_private.inc"
    
    SECTION code_driver

    PUBLIC _asci1_init

    EXTERN _asci1_reset
    EXTERN asm_z180_push_di, asm_z180_pop_ei_jp

    _asci1_init:
    
        call asm_z180_push_di       ; di

        ; initialise the ASCI1
                                    ; load the default ASCI configuration
                                    ; BAUD = 115200 8n1
                                    ; receive enabled
                                    ; transmit enabled
                                    ; receive interrupt enabled
                                    ; transmit interrupt disabled

        ld      a,CNTLA1_RE|CNTLA1_TE|CNTLA1_MODE_8N1
        out0    (CNTLA1),a          ; output to the ASCI1 control A reg

                                    ; PHI / PS / SS / DR = BAUD Rate
                                    ; PHI = 18.432MHz
                                    ; BAUD = 9600 = 18432000 / 30 / 1 / 64
                                    ; PS 1, SS_DIV_1, DR 1
        ld a,CNTLB1_PS|CNTLB1_DR|CNTLB1_SS_DIV_1
        out0    (CNTLB1),a          ; output to the ASCI1 control B reg

        ld      a,STAT1_RIE         ; receive interrupt enabled
        out0    (STAT1),a           ; output to the ASCI1 status reg

        jp asm_z180_pop_ei_jp       ; ei

