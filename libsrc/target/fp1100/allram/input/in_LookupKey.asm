; uint in_LookupKey(uchar c) __z88dk_fastcall: the scancode of an ASCII character: L = the matrix row (2 to 12), bit 7 set if shift has to be down
; with it; H = the key's mask (1 << bit, bits 0 to 6).  0 if there is no such key.  Uses af, bc, de, hl.

    SECTION code_clib
    PUBLIC  in_LookupKey
    PUBLIC  _in_LookupKey
    EXTERN  in_keytranstbl
    EXTERN  in_keytranstbl_shift

in_LookupKey:
_in_LookupKey:
    ld      a, l
    and     a
    jr      z, nokey
    ld      e, 0                        ; 0: the plain table, $80: the shifted
    ld      hl, in_keytranstbl
    call    search
    jr      nc, found
    ld      e, $80
    ld      hl, in_keytranstbl_shift
    call    search
    jr      nc, found
nokey:
    ld      hl, 0
    ret
; a = the character, hl = a table of 77: NC and bc = the index if it is there
search:
    ld      bc, 0
sr1:
    cp      (hl)
    jr      z, sr2
    inc     hl
    inc     bc
    ld      d, a
    ld      a, c
    cp      77
    ld      a, d
    jr      nz, sr1
    scf
    ret
sr2:
    and     a
    ret
found:
    ld      d, 0                        ; bc = row * 7 + bit
    ld      a, c
    ld      l, 0
fd1:
    cp      7
    jr      c, fd2
    sub     7
    inc     l
    jr      fd1
fd2:
    ld      c, a                        ; the bit
    ld      a, l
    add     a, 2                        ; the row
    or      e
    ld      l, a
    ld      h, 1
    inc     c
fd3:
    dec     c
    jr      z, fd4
    sla     h
    jr      fd3
fd4:
    ret
