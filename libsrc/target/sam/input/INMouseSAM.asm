; SAM Coupe mouse (RDMSEL, port $FFFE)
;
; Shared code for in_MouseSAMInit, in_MouseSAM and in_MouseSAMSetPos.
;
; The interface keeps the movement since it was last read in internal registers
; and sends it as a cycle of nine nibbles on port $FFFE: the strobe, the gate
; ($F, as cursor keys and Control give other values), the buttons (active low),
; then the Y and X deltas, high nibble before low.  Reading a tenth time starts
; the next cycle, so a scan is exactly nine reads.
;
; Movement is added to the coordinates in a 256x192 space (0,0 at top left).
;
; The state is in bss_clib: a program which pages memory (the SAM can map RAM
; over the area the bss is in) must have it mapped when it calls the mouse.

    SECTION code_clib
    PUBLIC  INMouseSAM
    PUBLIC  _INMouseSAM
    PUBLIC  INMouseSAMDetect
    PUBLIC  _in_SAMcoordX
    PUBLIC  _in_SAMcoordY
    PUBLIC  _in_SAMbuttons
    PUBLIC  _in_SAMpresent
    PUBLIC  _in_SAMretry
    PUBLIC  _in_SAMscan

DEFC SCAN_READS = 7                     ; after the strobe and the gate

; Read the mouse once.  If none has been found yet, look again every 30th call
; (an emulator may attach its mouse late).
; exit : C = buttons 00000MRL active high (the last ones if a cursor key blocked the scan)
;        HL = x coordinate (0..255)
;        DE = y coordinate (0..191)
; uses : AF,BC,DE,HL

INMouseSAM:
_INMouseSAM:
    ld      a, (_in_SAMpresent)
    or      a
    jr      nz, scan
    ld      hl, _in_SAMretry
    dec     (hl)
    jr      nz, done
    ld      (hl), 30
    call    INMouseSAMDetect            ; (the detecting scans do not move the position: a program may be moving it itself)
    ld      a, (_in_SAMpresent)
    or      a
    jr      z, done
scan:
    call    sam_scan
    call    nz, sam_update
done:
    ld      a, (_in_SAMbuttons)
    ld      c, a
    ld      hl, (_in_SAMcoordX)
    ld      de, (_in_SAMcoordY)
    ret

; One detection attempt: a scan to clear the interface's registers, then the
; detecting one.  A mouse at rest returns zero in the low nibbles of the six
; delta bytes of the second; with no mouse the port returns the keyboard state
; ($F there).
; exit : _in_SAMpresent set if a mouse answered
; uses : AF,BC,DE,HL

INMouseSAMDetect:
    call    sam_scan
    call    sam_scan
    ret     z                           ; (a held cursor key or Control fails the gate)
    ld      hl, scanbuf + 3
    ld      b, 6
    xor     a
detect_or:
    or      (hl)
    inc     hl
    djnz    detect_or
    and     $0f
    ret     nz
    ld      a, 1
    ld      (_in_SAMpresent), a
    ret

; Read one scan into scanbuf.  The interface starts a new cycle of nibbles after
; a pause in the reads, but a scan which follows another read of the port too
; closely (the keyboard's, or the last scan) carries on part-way through the
; old one and reads garbage: so wait first.
; exit : nz = scan good, z = the gate nibble was not $F (a cursor key or Control is down)
; uses : AF,BC,D,HL

sam_scan:
    ld      b, 0
settle:
    djnz    settle
    ld      bc, $fffe
    in      a, (c)                      ; strobe
    ld      hl, scanbuf
    ld      (hl), a
    inc     hl
    in      a, (c)                      ; gate
    ld      (hl), a
    inc     hl
    and     $0f
    cp      $0f
    jr      z, gate_ok
    xor     a                           ; z
    ret
gate_ok:
    ld      d, SCAN_READS               ; (b is the port's high byte)
read_loop:
    in      a, (c)
    ld      (hl), a
    inc     hl
    dec     d
    jr      nz, read_loop
    or      1                           ; nz: good
    ret

; Add the movement and the buttons from scanbuf.
; uses : AF,BC,DE,HL

sam_update:
    ld      a, (scanbuf + 7)            ; X delta, high nibble
    and     $0f
    rlca
    rlca
    rlca
    rlca
    ld      d, a
    ld      a, (scanbuf + 8)            ; low nibble
    and     $0f
    or      d
    ld      e, a
    rla                                 ; sign extend the 8-bit delta
    sbc     a, a
    ld      d, a
    ld      hl, (_in_SAMcoordX)
    add     hl, de
    ld      a, h
    inc     a
    jr      z, x_min                    ; went below zero
    cp      2
    jr      c, x_store
    ld      hl, 255
    jr      x_store
x_min:
    ld      hl, 0
x_store:
    ld      (_in_SAMcoordX), hl

    ld      a, (scanbuf + 4)            ; Y delta, high nibble
    and     $0f
    rlca
    rlca
    rlca
    rlca
    ld      d, a
    ld      a, (scanbuf + 5)
    and     $0f
    or      d
    neg                                 ; zero at the top
    ld      d, a
    ld      a, (_in_SAMcoordY)
    add     a, d
    cp      192
    jr      c, y_store
    xor     a
    bit     7, d
    jr      nz, y_store                 ; went above the top
    ld      a, 191
y_store:
    ld      l, a
    ld      h, 0
    ld      (_in_SAMcoordY), hl

    ld      a, (scanbuf + 2)            ; buttons, active low: bit 0 left, 1 middle, 2 right
    cpl
    ld      c, a
    and     1                           ; -> 00000MRL: left stays bit 0,
    ld      b, a
    ld      a, c
    and     4
    rrca                                ; right to bit 1
    or      b
    ld      b, a
    ld      a, c
    and     2
    rlca
    rlca                                ; middle to bit 2
    or      b
    ld      (_in_SAMbuttons), a
    ret

    SECTION bss_clib
_in_SAMscan:
scanbuf:        defs 9
_in_SAMcoordX:  defw 0
_in_SAMcoordY:  defw 0
_in_SAMbuttons: defb 0
_in_SAMpresent: defb 0
_in_SAMretry:   defb 0
