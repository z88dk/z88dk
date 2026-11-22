
    INCLUDE "config_private.inc"
    
    SECTION code_driver

    PUBLIC asm_asci0_init

    EXTERN asm_asci0_reset
    EXTERN asm_z180_push_di, asm_z180_pop_ei_jp

    asm_asci0_init:
    
        call asm_z180_push_di       ; di

        ; initialise the ASCI0
                                    ; load the default ASCI configuration
                                    ; BAUD = 115200 8n1
                                    ; receive enabled
                                    ; transmit enabled
                                    ; receive interrupt enabled
                                    ; transmit interrupt disabled

        ld      a,CNTLA0_RE|CNTLA0_TE|CNTLA0_MODE_8N2
        out0    (CNTLA0),a          ; output to the ASCI0 control A reg

                                    ; PHI / PS / SS / DR = BAUD Rate
                                    ; PHI = 36.864MHz
                                    ; BAUD = 115200 = 36864000 / 10 / 2 / 16 
                                    ; PS 0, SS_DIV_2, DR 0
                                    ; 115200 baud 8n2
        ld a,CNTLB0_SS_DIV_2
        out0    (CNTLB0),a          ; output to the ASCI0 control B reg

        ld      a,STAT0_RIE         ; receive interrupt enabled
        out0    (STAT0),a           ; output to the ASCI0 status reg

        jp asm_z180_pop_ei_jp       ; ei

