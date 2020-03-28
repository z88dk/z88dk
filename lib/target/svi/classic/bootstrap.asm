; -------------------------------------------------------------------------
;
;     Spectravideo SVI-328 z88dk Boot Sector
;
; -------------------------------------------------------------------------

    SECTION    BOOTSTRAP
    EXTERN  __DATA_END_tail
    org    $fd00

;
;    Bank switching ports
;
PSGLAW    equ    88H        ; PSG latch port
PSGDAW    equ    8CH        ; PSG write port
PSGDAR    equ    90H        ; PSG read port
;
;    Address definition
;
FDCCMD    equ    30H        ; Command to FDC
FDCSTT    equ    FDCCMD        ; Status from FDC
FDCTRK    equ    31H        ; Track register
FDCSEC    equ    32H        ; Sector register
FDCDAT    equ    33H        ; Data register
;
;    Command definition
;
RDCMD    equ    10000000B    ; Sector read command
;
;    Miscellaneous I/O ports
;
INTRQP    equ    34H        ; Address of INTRQ and DRQ
INTRQ    equ    10000000B    ; Interrupt request bit
DRQ    equ    01000000B    ; Data request bit
;
DENSEL    equ    38H        ; Address of density select flag
DESMFM    equ    00000000B    ; Density MFM bit
DESFM    equ    00000001B    ; Density FM bit
DESMFM2 equ     00000010B       ; Density MFM bit and side 2


;    ld    a, 11011101b    ; Bank 21
;    out    (PSGDAW), a    ; Register already set in ROM, just enable bank

;    ld    sp, 100h    ; Set temporary stack pointer

    ld    hl,$c100
    ld    de,$fd00
    ld    bc,128
    ldir
    jp    entry
entry:
    ld    b,17
    call  RDMSEC
    xor    a        
    out    (DENSEL), a    ; Set MFM density for rest of tracks
    ld    hl, 256
    ld    (BYTSEC+1), hl    ; Modify sector size
    ld    a, 18
    ld    (MAXSEC+1), a    ; Modify number of sectors / track


    ld    a,+((__DATA_END_tail - CRT_ORG_CODE )-2176) / 256 + 1
    ld    b,a
    and   a
    call  nz,RDMSEC
    jp    CRT_ORG_CODE    




;
;    Sector read routine
;
RDMSEC:
    push    bc
SETSEC:
    ld    a, 2
    out    (FDCSEC), a    ; Write to sector register

    ld    a, RDCMD    ; Sector read command
    out    (FDCCMD), a    ; Issue read command

    ld    c, FDCDAT
    ex    (sp), hl
    ex    (sp), hl
    ex    (sp), hl
    ex    (sp), hl
SETBUF:
    ld    hl, CRT_ORG_CODE ; Load destination address
RDLOP:
    in    a, (INTRQP)    ; Read data request port
    add   a
    jr    c, RDONE    ; Read confirmed
    jp    p, RDLOP    ; No data valid
    ini            ; Read data from FDC
    jr    RDLOP

RDONE:
    in    a, (FDCSTT)
    and   00011100b    ; Any errors detected?
    jr    nz, SETSEC
    ld    hl, (SETBUF+1)
BYTSEC:
    ld    de, 128        ; Sector size
    add   hl, de
    ld    (SETBUF+1), hl
    ld    hl,SETSEC+1
    inc   (hl)        ; Increase sector count
    ld    a, (hl)
MAXSEC:
    cp    19        ; Read all sectors?
    jr    c, DECSCZ

    ld    a, 1010010b    ; Issue    FDC STEP IN command
    out   (FDCCMD), a

    ld    (hl), 1

    ex    (sp), hl    ; Wait for the drive head
    ex    (sp), hl
    ex    (sp), hl
    ex    (sp), hl
BUSY:
    in    a, (FDCSTT)    ; Get FDC status
    rra            ; Look busy bit [LSB]
    jr    c, BUSY        ; Wait
DECSCZ:
    pop    bc
    djnz   RDMSEC
    ret

