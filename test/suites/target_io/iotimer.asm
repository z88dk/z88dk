;
; Guest view of the ticks cycle counter (-iotimer / -mmtimer).
;
; A write to the timer port resets the readable count. A read stores that
; count at tickbuf as 8 little-endian bytes and leaves A = 0. The emulator
; counter itself is not cleared: the Ticks line at exit stays ahead of the
; snapshot printed after the burn loop.
;
; Ports: -iochar 1, -iotimer 2.  -mmtimer tickbuf (symbol).
;
        org     0

        PUBLIC  tickbuf

        defc    IOCHAR = 1
        defc    IOTIMER = 2

IF __CPU_Z180__
        ; nop 3, in a,(n) 9
        defc    EXPECT_NOP = 12
        defc    EXPECT_IN = 9
ELSE
IF __CPU_8080__
        ; nop 4, in a,(n) 10. 8085 and vm1 price these the same.
        defc    EXPECT_NOP = 14
        defc    EXPECT_IN = 10
ELSE
        ; z80: nop 4, in a,(n) 11
        defc    EXPECT_NOP = 15
        defc    EXPECT_IN = 11
ENDIF
ENDIF

start:
        ld      sp, $ff00
        ld      b, 0
burn:
        nop
        dec     b
        jp      nz, burn

        in      a, (IOTIMER)
        or      a
        jp      nz, fail
        call    wide_ok
        ld      hl, tickbuf
        ld      e, (hl)
        inc     hl
        ld      d, (hl)

        ld      a, 'T'
        out     (IOCHAR), a
        ld      a, d
        call    phex
        ld      a, e
        call    phex

        out     (IOTIMER), a
        nop
        in      a, (IOTIMER)
        or      a
        jp      nz, fail
        ld      a, EXPECT_NOP
        call    expect_lo

        out     (IOTIMER), a
        in      a, (IOTIMER)
        or      a
        jp      nz, fail
        ld      a, EXPECT_IN
        call    expect_lo

        ld      a, 'P'
        out     (IOCHAR), a
        ld      l, 0
        xor     a
        defb    $ed, $fe

fail:
        ld      a, 'F'
        out     (IOCHAR), a
        ld      l, 1
        xor     a
        defb    $ed, $fe

; A = expected low byte. Bytes 1..7 are 0.
expect_lo:
        ld      hl, tickbuf
        cp      (hl)
        jp      nz, fail
        ld      b, 7
el_loop:
        inc     hl
        ld      a, (hl)
        or      a
        jp      nz, fail
        dec     b
        jp      nz, el_loop
        ret

; First snapshot covers the burn, so it is >= 256 and still fits in 16 bits.
wide_ok:
        ld      hl, tickbuf+1
        ld      a, (hl)
        or      a
        jp      z, fail
        ld      b, 6
wo_loop:
        inc     hl
        ld      a, (hl)
        or      a
        jp      nz, fail
        dec     b
        jp      nz, wo_loop
        ret

phex:
        push    af
        rrca
        rrca
        rrca
        rrca
        call    pdigit
        pop     af
pdigit:
        and     $0f
        add     a, '0'
        cp      '9'+1
        jp      c, pdigit_out
        add     a, 'A'-'0'-10
pdigit_out:
        out     (IOCHAR), a
        ret

tickbuf:
        defs    8
