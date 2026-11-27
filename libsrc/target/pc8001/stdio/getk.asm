;
;	NEC PC8001 Library
;
;	getk() Read key status
;
;	Based on the PC8801 version. The PC-8001 keyboard matrix is
;	ten rows read from ports $00 - $09 (active low).
;

    SECTION code_clib
    PUBLIC  getk
    PUBLIC  _getk


getk:
_getk:
    ld      hl, r1
    ld      d, 10
krloop:
    call    readkrow
    jr      nc, kfound
    dec     d
    ld      a, d
    jr      z, kfound
    inc     hl
    jr      krloop

kfound:
  IF    STANDARDESCAPECHARS
    cp      13
    jr      nz, not_return
    ld      a, 10
not_return:
  ENDIF

    ld      l, a
    ld      h, 0
    ret


; Entry: hl = row (port number, followed by eight key codes)
; Exit:  nc, a = key code if a key with a non-zero code is pressed
;        c if nothing found (hl points at the last code of the row)
readkrow:
    ld      c, (hl)
    ld      b, 0
    in      a, (c)
    ld      b, a
    ld      e, 8
e_lp:
    inc     hl
    rr      b
    jr      c, no_za
    ld      a, (hl)
    and     a
    ret     nz
no_za:
    dec     e
    jr      nz, e_lp
    scf
    ret

;--- --- --- ---

    SECTION data_clib

; Key Table

r1: defb    $00
    defb    '0'
    defb    '1'
    defb    '2'
    defb    '3'
    defb    '4'
    defb    '5'
    defb    '6'
    defb    '7'
r2: defb    $01
    defb    '8'
    defb    '9'
    defb    '*'
    defb    '+'
    defb    '='
    defb    ','
    defb    '.'
    defb    13
r3: defb    $02
    defb    '@'
    defb    'a'
    defb    'b'
    defb    'c'
    defb    'd'
    defb    'e'
    defb    'f'
    defb    'g'
r4: defb    $03
    defb    'h'
    defb    'i'
    defb    'j'
    defb    'k'
    defb    'l'
    defb    'm'
    defb    'n'
    defb    'o'
r5: defb    $04
    defb    'p'
    defb    'q'
    defb    'r'
    defb    's'
    defb    't'
    defb    'u'
    defb    'v'
    defb    'w'
r6: defb    $05
    defb    'x'
    defb    'y'
    defb    'z'
    defb    '['
    defb    92
    defb    ']'
    defb    '^'
    defb    '-'
r7: defb    $06
    defb    '0'
    defb    '1'
    defb    '2'
    defb    '3'
    defb    '4'
    defb    '5'
    defb    '6'
    defb    '7'
r8: defb    $07
    defb    '8'
    defb    '9'
    defb    ':'
    defb    ';'
    defb    ','
    defb    '.'
    defb    '/'
    defb    '_'
r9: defb    $08
    defb    12     ; CLR HOME
    defb    11     ; cursor UP
    defb    9      ; cursor RIGHT
    defb    8      ; DEL INS
    defb    0      ; GRPH
    defb    0      ; KANA
    defb    0      ; SHIFT
    defb    0      ; CTRL
r10:
    defb    $09
    defb    3      ; STOP
    defb    0      ; F1
    defb    0      ; F2
    defb    0      ; F3
    defb    0      ; F4
    defb    0      ; F5
    defb    ' '    ; SPACE
    defb    27     ; ESC
