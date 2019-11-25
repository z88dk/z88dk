
IF !(__page_zero_present)

SECTION code_crt_init
                            ; Internal register definitions begin
                            ; at __IO_BASE_ADDRESS = 0x0000

    xor     a               ; Zero Accumulator

                            ; Clear Refresh Control Reg (RCR)
    out0    (RCR),a         ; DRAM Refresh Enable (0 Disabled)

                            ; Clear INT/TRAP Control Register (ITC)             
    out0    (ITC),a         ; Disable all external interrupts.             

                            ; Set Operation Mode Control Reg (OMCR)
    ld      a,OMCR_M1E      ; Enable M1 for single step, disable 64180 I/O _RD Mode
    out0    (OMCR),a        ; X80 Mode (M1 Disabled, IOC Disabled)

                            ; DMA/Wait Control Reg Set I/O Wait States
    ld      a,DCNTL_MWI0|DCNTL_IWI1
    out0    (DCNTL),a       ; 1 Memory Wait & 3 I/O Wait
    
                            ; Set PHI = CCR x 2 = 36.864MHz
                            ; if using ZS8180 or Z80182 at High-Speed
    ld      a,CMR_X2        ; Set Hi-Speed flag
    out0    (CMR),a         ; CPU Clock Multiplier Reg (CMR)

                            ; Set CCR = crystal = 18.432MHz
                            ; if using ZS8180 or Z80182 at High-Speed
    ld      a,CCR_XTAL_X2   ; Set Hi-Speed flag
    out0    (CCR),a         ; CPU Control Reg (CCR)

                            ; Set Logical RAM Addresses
                            ; $F000-$FFFF RAM   CA1  -> $F.
                            ; $C000-$EFFF RAM   BANK
                            ; $0000-$BFFF Flash BANK -> $.0

    ld      a,$F0           ; Set New Common 1 / Bank Areas for RAM
    out0    (CBAR),a

    ld      a,$00           ; Set Common 1 Base Physical $0F000 -> $00
    out0    (CBR),a

    ld      a,$00           ; Set Bank Base Physical $00000 -> $00
    out0    (BBR),a

                            ; we do 256 ticks per second
    ld      hl,__CPU_CLOCK/__CPU_TIMER_SCALE/__CLOCKS_PER_SECOND-1 
    out0    (RLDR0L),l
    out0    (RLDR0H),h
                            ; enable down counting and interrupts for PRT0
    ld      a,TCR_TIE0|TCR_TDE0
    out0    (TCR),a         ; using the driver/z180/system_tick.asm

    EXTERN  asm_asci0_init
    call    asm_asci0_init  ; initialise the asci0

    EXTERN  asm_asci1_init
    call    asm_asci1_init  ; and the asci1 interfaces

ENDIF
