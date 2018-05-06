
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
                                    ; BAUD = 115200 = 18432000 / 10 / 1 / 16 
                                    ; PS 0, SS_DIV_1 0, DR 0           
        xor     a                   ; BAUD = 115200
        out0    (CNTLB1),a          ; output to the ASCI1 control B reg

        ld      a,STAT1_RIE         ; receive interrupt enabled
        out0    (STAT1),a           ; output to the ASCI1 status reg
        
        call _asci1_reset           ; reset empties and initialises the Tx & Rx buffers

        jp asm_z180_pop_ei_jp       ; ei

