; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; int remove(const char *name);
; An open descriptor for that name is closed, so a later read fails.
; A graph equation is left in place. Deleting one crashes the calculator.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  remove
    PUBLIC  _remove

    EXTERN  ti_name
    EXTERN  ti_find
    EXTERN  ti_files
    EXTERN  ti_errno

remove:
_remove:
    push    ix
    ld      ix, 4
    add     ix, sp
    ld      l, (ix+0)
    ld      h, (ix+1)
    pop     ix
    call    ti_name
    jr      c, rm_inval
    ld      hl, OP1
    ld      de, rm_name
    ld      bc, 9
    ldir
    call    ti_find
    jr      c, rm_inval
    cp      EquObj
    jr      z, rm_nosup
    cp      NewEquObj
    jr      z, rm_nosup
    ld      (rm_vat), hl
    ld      (rm_data), de
    ld      a, b
    ld      (rm_page), a
    call    rm_drop
    ld      hl, (rm_vat)
    ld      de, (rm_data)
    ld      a, (rm_page)
    ld      b, a
    TICALL  _DelVarArc
    ld      hl, 0
    ret

rm_nosup:
    ld      a, ENOTSUP
    jp      ti_errno

rm_inval:
    ld      a, EINVAL
    jp      ti_errno

; Clear every open slot whose stored name matches rm_name.
rm_drop:
    ld      hl, ti_files
    ld      b, TI_NSLOTS
rm_loop:
    push    bc
    push    hl
    ld      de, rm_name
    ld      b, 9
rm_cmp:
    ld      a, (de)
    cp      (hl)
    jr      nz, rm_next
    inc     de
    inc     hl
    djnz    rm_cmp
    ld      de, fs_flags - 9
    add     hl, de
    ld      (hl), 0
rm_next:
    pop     hl
    ld      de, TI_SLOT
    add     hl, de
    pop     bc
    djnz    rm_loop
    ret

    SECTION bss_clib

rm_name:
    defs    9

rm_vat:
    defw    0

rm_data:
    defw    0

rm_page:
    defb    0

ENDIF
