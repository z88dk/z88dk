
    INCLUDE "config_private.inc"
    
    SECTION code_driver

    PUBLIC asm_asci1_init

    EXTERN asm_asci1_reset
    EXTERN asm_z180_push_di, asm_z180_pop_ei_jp

    asm_asci1_init:
    
        call asm_z180_push_di       ; di

        ; initialise the ASCI1
                                    ; load the default ASCI configuration
                                    ; BAUD = 115200 8n1
                                    ; receive enabled
                                    ; transmit enabled
                                    ; receive interrupt enabled
                                    ; transmit interrupt disabled

        ld      a,CNTLA1_RE|CNTLA1_TE|CNTLA1_MODE_8N2
        out0    (CNTLA1),a          ; output to the ASCI1 control A reg

                                    ; PHI / PS / SS / DR = BAUD Rate
                                    ; PHI = 36.864MHz
                                    ; BAUD = 9600 = 36864000 / 30 / 2 / 64
                                    ; PS 1, SS_DIV_2, DR 1
                                    ; 9600 baud 8n2
        ld a,CNTLB1_PS|CNTLB1_DR|CNTLB1_SS_DIV_2
        out0    (CNTLB1),a          ; output to the ASCI1 control B reg

        ld      a,STAT1_RIE         ; receive interrupt enabled
        out0    (STAT1),a           ; output to the ASCI1 status reg

        jp asm_z180_pop_ei_jp       ; ei

