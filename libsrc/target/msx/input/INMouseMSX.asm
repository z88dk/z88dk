; MSX mouse (in a joystick port)
;
; Shared code for in_MouseMSXInit, in_MouseMSX and in_MouseMSXSetPos.  Valid for the MSX1 and MSX2 (it is the PSG's ports $A0/$A1/$A2 and the mouse
; protocol: the mouse is read as joystick connector pins).
;
; The mouse reports how far it has moved since it was last read; this keeps a position, 0..255 by 0..191 as in_MouseKemp does, and adds the movement to it
; (so a program can move the position too: in_MouseMSXSetPos).  The connector (port 1 or 2) is in _in_MSXport.
;
; The protocol: PSG register 15 (output) has bit 6 to choose the connector whose pins register 14 (input) reads, and the connector's pin 8 as the
; mouse's strobe (bit 4 for port 1, bit 5 for port 2), with bits 0 to 3 left high (the pins 6 and 7, the buttons').  Register 14 gives the buttons in bits 4 and
; 5 (pins 6 and 7, active low) and four bits of data in bits 0 to 3.  After the strobe has been low a while the mouse is ready to send: the strobe going high
; gives the high nibble of the X movement, low the low nibble, high the high nibble of Y and low the low nibble of Y.  The movement is a signed byte that is
; the NEGATIVE of the way the mouse moved (right and down are negative values).  With no mouse (or one that does not answer) the pins are pulled
; up and a read is $FF for both: a mouse that is there says $FF only when it has moved one step right and one down at once, so this takes it for none.  (The mouse
; resets its counters when it is read; msx.org's Mouse/Trackball page has the protocol and the detection.)
;
; Timing: the mouse wants at least 0.18 ms between the strobe's edges, and about 1 ms after the first for the counters to be latched: the waits below are 0.35 ms and 1 ms
; for a Z80 at 3.58 MHz (the interrupts are off for the whole read, about 2.5 ms).  A turbo R in its R800 mode is faster and would need longer waits.
;
; The state is in bss_clib.

    SECTION code_clib
    PUBLIC  INMouseMSX
    PUBLIC  _INMouseMSX
    PUBLIC  asm_in_MouseMSXClamp
    PUBLIC  _in_MSXcoordX
    PUBLIC  _in_MSXcoordY
    PUBLIC  _in_MSXbuttons
    PUBLIC  _in_MSXpresent
    PUBLIC  _in_MSXport

DEFC PSG_ADDR = $A0
DEFC PSG_WRITE = $A1
DEFC PSG_READ = $A2
DEFC SHORT = 78                 ; (16 T states a count: 0.35 ms)
DEFC LONG = 234                 ; (1 ms)

; Read the mouse once.
; exit : C = buttons 00000MRL (active high; none if there is no mouse)
;        HL = x coordinate (0..255)
;        DE = y coordinate (0..191)
; uses : AF,BC,DE,HL

INMouseMSX:
_INMouseMSX:
    ld      a, i                        ; (P/V is the interrupt flip-flop: kept for the end)
    push    af
    di
    ld      a, (_in_MSXport)
    cp      2
    ld      bc, $1000                   ; b = port 1's strobe (pin 8), c = the connector select bit (0 for port 1)
    jr      nz, port_set
    ld      bc, $2040                   ; port 2
port_set:
    ld      a, 15
    out     (PSG_ADDR), a
    in      a, (PSG_READ)
    and     $80                         ; (the kana LED's bit is left as it is)
    or      $0F
    or      c
    ld      d, a                        ; d = register 15 with the strobe low
    ld      l, SHORT
    call    phase                       ; the strobe low (and the time for the mouse to be ready)
    ld      a, d
    or      b
    ld      l, LONG
    call    phase                       ; the strobe high (the counters are latched): the high nibble of x
    and     $0F
    ld      (nibbles), a
    ld      a, d
    ld      l, SHORT
    call    phase                       ; low: the low nibble of x (and the buttons)
    ld      e, a
    and     $0F
    ld      (nibbles + 1), a
    ld      a, e
    cpl
    rrca
    rrca
    rrca
    rrca
    and     3                           ; buttons, active high: bit 0 left (pin 6), bit 1 right (pin 7)
    ld      (_in_MSXbuttons), a
    ld      a, d
    or      b
    ld      l, SHORT
    call    phase                       ; high: the high nibble of y
    and     $0F
    ld      (nibbles + 2), a
    ld      a, d
    ld      l, SHORT
    call    phase                       ; low: the low nibble of y
    and     $0F
    ld      (nibbles + 3), a
    pop     af                          ; the interrupts as they were
    jp      po, no_ei
    ei
no_ei:
    ; x = (nibbles[0] << 4) | nibbles[1], y the same
    ld      a, (nibbles)
    rlca
    rlca
    rlca
    rlca
    ld      hl, nibbles + 1
    or      (hl)
    ld      b, a                        ; b = the x byte
    ld      a, (nibbles + 2)
    rlca
    rlca
    rlca
    rlca
    inc     hl
    inc     hl
    or      (hl)
    ld      c, a                        ; c = the y byte
    and     b
    inc     a
    jr      z, no_mouse                 ; both $FF
    ld      a, 1
    ld      (_in_MSXpresent), a
    ld      a, b                        ; the movement is minus the byte (signed)
    neg
    ld      e, a
    add     a, a
    sbc     a, a
    ld      d, a
    ld      hl, (_in_MSXcoordX)
    add     hl, de
    ld      de, 255
    call    asm_in_MouseMSXClamp
    ld      (_in_MSXcoordX), hl
    ld      a, c
    neg
    ld      e, a
    add     a, a
    sbc     a, a
    ld      d, a
    ld      hl, (_in_MSXcoordY)
    add     hl, de
    ld      de, 191
    call    asm_in_MouseMSXClamp
    ld      (_in_MSXcoordY), hl
done:
    ld      a, (_in_MSXbuttons)
    ld      c, a
    ld      hl, (_in_MSXcoordX)
    ld      de, (_in_MSXcoordY)
    ret
no_mouse:
    xor     a
    ld      (_in_MSXbuttons), a
    ld      (_in_MSXpresent), a
    jr      done

; Write a to PSG register 15, wait for the mouse (l times 16 T states: SHORT is about 0.35 ms, LONG about 1 ms, for a Z80 at 3.58 MHz), and read register 14 into a.
; uses : AF,E,H

phase:
    ld      e, a
    ld      a, 15
    out     (PSG_ADDR), a
    ld      a, e
    out     (PSG_WRITE), a
    ld      h, l
wait:
    dec     h
    jr      nz, wait
    ld      a, 14
    out     (PSG_ADDR), a
    in      a, (PSG_READ)
    ret

; Limit hl to 0..de.
; enter : hl = value (signed), de = the limit
; exit  : hl limited
; uses  : AF,HL

asm_in_MouseMSXClamp:
    bit     7, h
    jr      z, positive
    ld      hl, 0
    ret
positive:
    ld      a, e
    sub     l
    ld      a, d
    sbc     a, h
    ret     nc
    ex      de, hl
    ret

    SECTION bss_clib
nibbles:        defs 4
_in_MSXcoordX:  defw 0
_in_MSXcoordY:  defw 0
_in_MSXbuttons: defb 0
_in_MSXpresent: defb 0
_in_MSXport:    defb 0
