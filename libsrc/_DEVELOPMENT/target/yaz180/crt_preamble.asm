
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
                            ; $E000-$FFFF RAM   CA1  -> $E.
                            ; $D000-$DFFF RAM   BANK
                            ; $0000-$CFFF Flash BANK -> $.0

    LD      A,$E0           ; Set New Common 1 / Bank Areas for RAM
    OUT0    (CBAR),A

    LD      A,$00           ; Set Common 1 Base Physical $0D000 -> $00
    OUT0    (CBR),A

    LD      A,$00           ; Set Bank Base Physical $00000 -> $00
    OUT0    (BBR),A

ENDIF
