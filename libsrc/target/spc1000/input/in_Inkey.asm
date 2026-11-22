; uint in_Inkey(void)
; 07.2018 suborb

; Read current state of keyboard but only return
; keypress if a single key is pressed.  (Shift and Ctrl, in row 0, do not
; count as keys: they pick the table the key is looked up in.)

    SECTION code_clib
    PUBLIC  in_Inkey
    PUBLIC  _in_Inkey
    EXTERN  in_keytranstbl

; exit : carry set and HL = 0 for no keys registered (or more than one)
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;
; Rows 1 to 9 are read from $8001 to $8009 (a clear bit is a key down); only
; the bits that have keys count (the rest of them are not connected).  The
; table has a row of 8 codes, bit 7 first.

in_Inkey:
_in_Inkey:
    ld      bc, $8001
    ld      hl, in_Inkey_masks
    ld      e, 0                        ; the table offset of the key found (0: none yet)
rowloop:
    in      a, (c)
    cpl
    and     (hl)                        ; only the bits that are keys
    inc     hl
    jr      z, nextrow
    ld      d, a
    dec     a
    and     d                           ; the lowest bit cleared: not zero if there were two keys in this row
    jr      nz, nokey
    ld      a, e
    and     a
    jr      nz, nokey                   ; a key in an earlier row as well
    ld      a, c                        ; the row * 8,
    add     a, a
    add     a, a
    add     a, a
    ld      e, a
    ld      a, d                        ; plus the position of the bit, from bit 7
bitloop:
    rlca
    jr      c, nextrow
    inc     e
    jr      bitloop
nextrow:
    inc     c
    ld      a, c
    cp      10
    jr      nz, rowloop
    ld      a, e
    and     a
    jr      z, nokey
    ld      d, 0                        ; de = the offset
    ; Check for shift and control
    ld      bc, $8000
    in      a, (c)
    ld      bc, 80*2
    bit     2, a                        ; CTRL
    jr      z, got_modifier
    ld      bc, 80
    bit     1, a                        ;SHIFT
    jr      z, got_modifier
    ld      bc, 0
got_modifier:
    ld      hl, in_keytranstbl
    add     hl, bc
    add     hl, de
    ld      a, (hl)
    cp      255
    jr      z, nokey
    ld      l, a
    ld      h, 0
    and     a
    ret
nokey:
    ld      hl, 0
    scf
    ret

    SECTION rodata_clib
in_Inkey_masks:
    defb    @11111111                   ; row 1
    defb    @11111101                   ; 2
    defb    @11111101                   ; 3
    defb    @11111100                   ; 4
    defb    @11110110                   ; 5
    defb    @11111110                   ; 6
    defb    @11111110                   ; 7
    defb    @11111110                   ; 8
    defb    @11111110                   ; 9
