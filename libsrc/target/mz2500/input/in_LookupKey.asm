; uint in_LookupKey(uchar c)

    SECTION code_clib
    PUBLIC  in_LookupKey
    PUBLIC  _in_LookupKey
    EXTERN  in_keytranstbl

; enter: L = ascii character code
; exit : carry set & HL=0 if ascii code not found
;        else: L = column + flags (bit 7 if SHIFT needs to be pressed, bit 6 if CTRL), H = mask
; uses : AF,BC,DE,HL

; The 16-bit value returned is a scan code understood by in_KeyPressed.

in_LookupKey:
_in_LookupKey:
    ld      a, l
    cp      $ff
    jr      z, notfound
    ld      hl, in_keytranstbl
    ld      bc, 96 * 3
    cpir
    jr      nz, notfound
    ld      hl, 96 * 3 - 1
    and     a
    sbc     hl, bc                      ; hl = position within the tables
    ld      d, 0                        ; the flags
    ld      bc, 96
    and     a
    sbc     hl, bc
    jr      c, got_table
    ld      d, $80                      ; SHIFT
    and     a
    sbc     hl, bc
    jr      c, got_table
    ld      d, $40                      ; CTRL
    and     a
    sbc     hl, bc
got_table:
    add     hl, bc                      ; hl = 0..95
    ld      a, l
    ld      e, a
    rra
    rra
    rra
    and     15
    or      d
    ld      d, a                        ; column + flags
    ld      a, e
    and     7                           ; the bit
    ld      h, 1
shift_loop:
    jr      z, shifted
    sla     h
    dec     a
    jr      shift_loop
shifted:
    ld      l, d
    and     a
    ret

notfound:
    ld      hl, 0
    scf
    ret
