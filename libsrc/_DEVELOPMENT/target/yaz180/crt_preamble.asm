
IF (__crt_org_code = 0)

SECTION code_crt_init

EXTERN OMCR_M1E, CMR_X2, DCNTL_IWI0

    XOR     A               ; Zero Accumulator

                            ; Clear Refresh Control Reg (RCR)
    OUT0    (RCR),A         ; DRAM Refresh Enable (0 Disabled)

    OUT0    (TCR),A         ; Disable PRT downcounting

                            ; Clear INT/TRAP Control Register (ITC)             
    OUT0    (ITC),A         ; Disable all external interrupts.             

                            ; Set Operation Mode Control Reg (OMCR)
    LD      A,OMCR_M1E      ; Enable M1 for single step, disable 64180 I/O _RD Mode
    OUT0    (OMCR),A        ; X80 Mode (M1 Disabled, IOC Disabled)

                            ; Set internal clock = crystal x 2 = 36.864MHz
                            ; if using ZS8180 or Z80182 at High-Speed
    LD      A,CMR_X2        ; Set Hi-Speed flag
    OUT0    (CMR),A         ; CPU Clock Multiplier Reg (CMR)

                            ; DMA/Wait Control Reg Set I/O Wait States
    LD      A,DCNTL_IWI0
    OUT0    (DCNTL),A       ; 0 Memory Wait & 2 I/O Wait

                            ; Set Logical RAM Addresses
                            ; $8000-$FFFF RAM CA1 -> 80H
                            ; $4000-$7FFF RAM BANK -> 04H
                            ; $2000-$3FFF RAM CA0
                            ; $0000-$1FFF Flash CA0
                            
    LD      A,84H           ; Set New Common / Bank Areas for RAM
    OUT0    (CBAR),A
    LD      A,78H           ; Set Common 1 Area Physical $80000 -> 78H
    OUT0    (CBR),A
    LD      A,3CH           ; Set Bank Area Physical $40000 -> 3CH
    OUT0    (BBR),A

ENDIF
