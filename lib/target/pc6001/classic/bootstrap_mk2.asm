;
; Boot sector for a program on a PC-6001mkII disc (-subtype=mk2disc): the whole
; machine, with the ROM mapped out.
;
; The mkII's BASIC ROM, when it finds a drive, reads track 0 sector 1 to $F900
; and calls $F903 if the sector starts with "SYS" (its own code at $6018).  The
; program is the flat image that starts at CRT_ORG_CODE (normally $0000, which
; is under the ROM) up to the end of the initialised data; it is on the disc
; from track 1, a whole number of tracks of 16 sectors of 256 bytes (appmake
; +pc6001mk2).  This reads it a track at a time with the ROM's own disc routine
; ($5CFD: a = sectors, b = track, c = sector, hl = destination, carry clear to
; read) into a buffer at $E000 and copies each track down with $F2 = $55 (all
; RAM writable, reads still giving the ROM) for just the length of the copy: the
; ROM routine keeps a "current track" byte through ($FB33), which at boot points
; into $0506, so it must never be called with that RAM writable.  Then $F0 and
; $F1 = $DD map all RAM in and the program starts at CRT_ORG_CODE.
;
; It first checks that the ROM is the mkII's (its code at $6018), and returns to
; the ROM, having touched nothing, if not: the ports used below are the mkII's,
; and on the original PC-6001 $B0 is the system latch.  It shows a heading on a
; 40x20 text screen of its own (VRAM at $C000: attributes, then the characters
; at $C400; $C1 is written before $B0 as an emulator takes the VRAM base at the
; $B0 write) and a dot for each track loaded.
;
; The program must be at least a track long below $E000 and not overlap this
; sector or the buffer: the image is checked against the disc by appmake.

  IF    startup=5

    SECTION     BOOTSTRAP
    EXTERN      __DATA_END_tail
    org         $f900

    defm        "SYS"
    ld          hl, $6018
    ld          de, romsig
    ld          b, 8
romck:
    ld          a, (de)
    cp          (hl)
    ret         nz                      ; not a PC-6001mkII: back to the ROM
    inc         hl
    inc         de
    djnz        romck
    di
    ld          sp, $f8f0
    ld          a, 4
    out         ($c1), a
    ld          a, 3
    out         ($b0), a
    ld          hl, $c000               ; attributes: white on black
    ld          de, $c001
    ld          bc, $03ff
    ld          (hl), $0f
    ldir
    ld          hl, $c400               ; characters: blank
    ld          de, $c401
    ld          bc, $03ff
    ld          (hl), 0
    ldir
    ld          hl, title
    ld          de, $c400+40+2
    ld          bc, title_end-title
    ldir
    ld          hl, $c400+3*40+2
    ld          (dots), hl
    ld          hl, CRT_ORG_CODE
    ld          (dest), hl
    ld          b, 1                    ; the track
next:
    push        bc
    ld          hl, $e000
    ld          a, 16
    ld          c, 1
    or          a                       ; carry clear: read
    call        $5cfd
    ld          a, $55
    out         ($f2), a
    ld          hl, $e000
    ld          de, (dest)
    ld          bc, $1000
    ldir
    ld          (dest), de
    ld          a, $50                  ; the default: only $8000 and up writable
    out         ($f2), a
    ld          hl, (dots)              ; a dot for the track
    ld          (hl), '.'
    inc         hl
    ld          (dots), hl
    pop         bc
    inc         b
    ld          a, b
    cp          +(((__DATA_END_tail-CRT_ORG_CODE)+4095)/4096)+1
    jr          nz, next
    ld          a, $55
    out         ($f2), a
    ld          a, $dd
    out         ($f0), a
    out         ($f1), a
    jp          CRT_ORG_CODE

dest:
    defw        0
dots:
    defw        0
; the mkII's BASIC ROM at $6018
romsig:
    defb        $dd, $2a, $29, $ff, $cd, $b9, $42, $30
title:
    defm        "Z88DK NEC PC-6001MKII BOOTLOADER"
title_end:

  ENDIF
