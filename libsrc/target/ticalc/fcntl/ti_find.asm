; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Find the variable named in OP1.
; Carry set: not found, or the stored type is not the requested type.
; Carry clear: A = type, B = page, HL = symbol entry, DE = start of data.
; Page 0 is RAM. ChkFindSym's data pointer for an archived variable is the
; flag byte of the archive entry.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  ti_find

ti_find:
    ld      a, (OP1)
    push    af
    cp      AppVarObj
    jr      z, tf_chk
    cp      ProgObj
    jr      z, tf_chk
    cp      GroupObj
    jr      z, tf_chk
    TICALL  _FindSym
    jr      tf_got
tf_chk:
    TICALL  _ChkFindSym
tf_got:
    jp      c, tf_miss
    and     $1f
    push    hl
    push    de
    push    bc
    ld      e, a
    pop     bc
    ld      d, b
    pop     bc
    pop     hl
    pop     af
    cp      e
    jr      z, tf_move
    cp      ListObj
    jr      nz, tf_equ
    ld      a, e
    cp      CListObj
    jr      z, tf_move
    scf
    ret
tf_equ:
    cp      EquObj
    jr      nz, tf_prog
    ld      a, e
    cp      NewEquObj
    jr      z, tf_move
    scf
    ret
tf_prog:
    cp      ProgObj
    jr      nz, tf_no
    ld      a, e
    cp      ProtProgObj
    jr      z, tf_move
tf_no:
    scf
    ret

tf_move:
    ld      a, e
    push    bc
    ld      b, d
    pop     de
    or      a
    ret

tf_miss:
    pop     af
    scf
    ret

ENDIF
