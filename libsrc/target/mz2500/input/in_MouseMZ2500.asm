; Sharp MZ-2500 mouse (the SIO's channel B)
;
;	int  in_MouseMZ2500Init(void);
;	void in_MouseMZ2500(uchar *buttons, uint *xcoord, uint *ycoord);
;	void in_MouseMZ2500SetPos(uint xcoord, uint ycoord);
;	(and _callee versions of the last two)
;
; The mouse is on the SIO's channel B ($A2 data, $A3 control); the YM2203's port A bit 3 selects it.  Taking DTR low makes it send
; three bytes: the buttons and overflow bits (bit 0 left, bit 1 right, bits 4/5 x overflow right/left, bits 6/7 y overflow down/up),
; then the x and y movements as signed bytes.  in_MouseMZ2500 reads the bytes that have arrived since the last call, adds the movement
; to the position (kept within 0..319 and 0..199) and takes DTR low and high again for the next packet, so call it once a frame or so.
; A packet that is incomplete at the next call is dropped.  Buttons are 00000MRL, active high (M is always 0).
; in_MouseMZ2500Init sets the position to (0,0).  A mouse cannot be detected, so it always returns non-zero.
; The state is in bss_clib.
;

    SECTION code_clib
    PUBLIC  in_MouseMZ2500Init
    PUBLIC  _in_MouseMZ2500Init
    PUBLIC  in_MouseMZ2500Present
    PUBLIC  _in_MouseMZ2500Present
    PUBLIC  in_MouseMZ2500
    PUBLIC  _in_MouseMZ2500
    PUBLIC  in_MouseMZ2500_callee
    PUBLIC  _in_MouseMZ2500_callee
    PUBLIC  in_MouseMZ2500SetPos
    PUBLIC  _in_MouseMZ2500SetPos
    PUBLIC  in_MouseMZ2500SetPos_callee
    PUBLIC  _in_MouseMZ2500SetPos_callee

in_MouseMZ2500Init:
_in_MouseMZ2500Init:
    ld      a, $0e                      ; the YM2203's port A: the mouse select
    out     ($c8), a
    in      a, ($c9)
    or      8
    out     ($c9), a
    ld      a, $18                      ; channel B reset
    out     ($a3), a
    ld      a, 4                        ; WR4: x16 clock, 1 stop bit, no parity
    out     ($a3), a
    ld      a, $44
    out     ($a3), a
    ld      a, 3                        ; WR3: 8 bits, receiver on
    out     ($a3), a
    ld      a, $c1
    out     ($a3), a
    ld      a, 5                        ; WR5: 8 bits, DTR off
    out     ($a3), a
    ld      a, $60
    out     ($a3), a
    ld      hl, 0
    ld      (mx), hl
    ld      (my), hl
    xor     a
    ld      (mbtn), a
    ld      (mcnt), a
in_MouseMZ2500Present:
_in_MouseMZ2500Present:
    ld      hl, 1
    ret

in_MouseMZ2500SetPos:
_in_MouseMZ2500SetPos:
    pop     de
    pop     bc                          ; ycoord
    pop     hl                          ; xcoord
    push    hl
    push    bc
    push    de
    ld      (mx), hl
    ld      (my), bc
    ret

in_MouseMZ2500SetPos_callee:
_in_MouseMZ2500SetPos_callee:
    pop     de
    pop     bc                          ; ycoord
    pop     hl                          ; xcoord
    push    de
    ld      (mx), hl
    ld      (my), bc
    ret

in_MouseMZ2500:
_in_MouseMZ2500:
    call    poll
    pop     de                          ; return address
    pop     hl                          ; y
    ld      bc, (my)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; x
    ld      bc, (mx)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; buttons
    ld      a, (mbtn)
    ld      (hl), a
    push    hl
    push    hl
    push    hl
    ex      de, hl
    jp      (hl)

in_MouseMZ2500_callee:
_in_MouseMZ2500_callee:
    call    poll
    pop     de                          ; return address
    pop     hl                          ; y
    ld      bc, (my)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; x
    ld      bc, (mx)
    ld      (hl), c
    inc     hl
    ld      (hl), b
    pop     hl                          ; buttons
    ld      a, (mbtn)
    ld      (hl), a
    ex      de, hl
    jp      (hl)

; Collect the bytes that have arrived, three to a packet, then ask for the next
poll:
    xor     a
    ld      (mgot), a
poll_loop:
    in      a, ($a3)
    and     1
    jr      z, poll_end
    in      a, ($a2)
    ld      e, a
    ld      a, 1
    ld      (mgot), a
    ld      a, (mcnt)
    ld      c, a
    ld      b, 0
    ld      hl, mbuf
    add     hl, bc
    ld      (hl), e
    inc     c
    ld      a, c
    ld      (mcnt), a
    cp      3
    jr      nz, poll_loop
    xor     a
    ld      (mcnt), a
    call    packet
    jr      poll_loop
poll_end:
    ld      a, (mgot)
    or      a
    jr      nz, trigger
    ld      (mcnt), a                   ; (nothing came: a partial packet is dropped)
trigger:
    ld      a, 5                        ; DTR off and on again
    out     ($a3), a
    ld      a, $60
    out     ($a3), a
    ld      a, 5
    out     ($a3), a
    ld      a, $e0
    out     ($a3), a
    ld      hl, (mx)
    ld      de, 319
    call    clamp
    ld      (mx), hl
    ld      hl, (my)
    ld      de, 199
    call    clamp
    ld      (my), hl
    ret

; A whole packet in mbuf: add the movement to the position
packet:
    ld      a, (mbuf)
    ld      b, a
    and     3
    ld      (mbtn), a
    ld      a, (mbuf + 1)               ; x
    ld      l, a
    ld      h, 0
    bit     7, l
    jr      z, pk_x
    dec     h
pk_x:
    bit     4, b
    jr      z, pk_xl
    ld      hl, 127
    jr      pk_xd
pk_xl:
    bit     5, b
    jr      z, pk_xd
    ld      hl, -128
pk_xd:
    ld      de, (mx)
    add     hl, de
    ld      (mx), hl
    ld      a, (mbuf + 2)               ; y
    ld      l, a
    ld      h, 0
    bit     7, l
    jr      z, pk_y
    dec     h
pk_y:
    bit     6, b
    jr      z, pk_yl
    ld      hl, 127
    jr      pk_yd
pk_yl:
    bit     7, b
    jr      z, pk_yd
    ld      hl, -128
pk_yd:
    ld      de, (my)
    add     hl, de
    ld      (my), hl
    ret

; HL = value (signed), DE = maximum: HL clamped to 0..DE
clamp:
    bit     7, h
    jr      z, clamp_hi
    ld      hl, 0
    ret
clamp_hi:
    push    hl
    ex      de, hl
    push    hl
    or      a
    sbc     hl, de                      ; maximum - value
    pop     hl                          ; (the maximum)
    pop     de                          ; (the value)
    ret     c
    ex      de, hl
    ret

    SECTION bss_clib
mx:     defw    0
my:     defw    0
mbtn:   defb    0
mcnt:   defb    0
mgot:   defb    0
mbuf:   defs    3
