
IF (__page_zero_present)

SECTION code_crt_init

    XOR     A               ; Zero Accumulator

                            ; Clear Refresh Control Reg (RCR)
    OUT0    (RCR),A         ; DRAM Refresh Enable (0 Disabled)

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
                            ; $F000-$FFFF RAM   CA1  -> $F.
                            ; $C000-$EFFF RAM   BANK
                            ; $0000-$BFFF Flash BANK -> $.0

    LD      A,$F0           ; Set New Common 1 / Bank Areas for RAM
    OUT0    (CBAR),A

    LD      A,$00           ; Set Common 1 Base Physical $0F000 -> $00
    OUT0    (CBR),A

    LD      A,$00           ; Set Bank Base Physical $00000 -> $00
    OUT0    (BBR),A

                            ; we do 256 ticks per second
    ld      hl, __CPU_CLOCK/__CPU_TIMER_SCALE/256-1 
    out0    (RLDR0L), l
    out0    (RLDR0H), h
                            ; enable down counting and interrupts for PRT0
    ld      a, TCR_TIE0|TCR_TDE0
    out0    (TCR), a        ; using the driver/z180/system_tick.asm

    EXTERN  _asci0_init
    call    _asci0_init     ; initialise the asci0

    EXTERN  _asci1_init
    call    _asci1_init     ; and the asci1 interfaces

ENDIF
