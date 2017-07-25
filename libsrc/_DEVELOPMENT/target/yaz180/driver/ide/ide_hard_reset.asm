
SECTION code_driver

PUBLIC ide_hard_reset

EXTERN PIO_IDE_CTL, PIO_IDE_CONFIG
EXTERN PIO_IDE_RD

EXTERN  IDE_RST_LINE

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; do a hard reset on the drive, by pulsing its reset pin.
; do this first, and if a soft reset doesn't work.
; this should be followed with a call to "ide_init".

ide_hard_reset:
    push af
    push bc
    ld bc, PIO_IDE_CONFIG
    ld a, PIO_IDE_RD
    out (c), a          ;config 8255 chip, read mode
    ld bc, PIO_IDE_CTL
    ld a, IDE_RST_LINE
    out (c),a           ;hard reset the disk drive
    ld b, $0
ide_rst_dly:
    djnz ide_rst_dly   ;delay 256 nop 150us (reset minimum 25us)
    ld bc, PIO_IDE_CTL
    xor a
    out (c),a           ;no ide control lines asserted
    pop bc
    pop af
    ret

