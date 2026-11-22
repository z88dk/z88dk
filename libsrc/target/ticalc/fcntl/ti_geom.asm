; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Measure a variable found by ti_find.
;
; In:  A = type, B = page, HL = symbol entry, DE = data.
;      Page 0 is RAM. An archived DE is the flag byte, not the payload.
; Out: A = TI_ARCH / TI_GROW / TI_HSIZE, B = page of the payload,
;      DE = first payload byte, HL = payload size. Carry set on a bad
;      header (a matrix whose dimension is 0 or greater than 99).
;
; WikiTI stores an archived variable as flag, size, then a forward
; symbol entry: T, T2, version, address, page, name length, name.
; The name length is the byte at offset 9. Payload follows the name.
; GDB and group files are the whole data block and do not grow.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  ti_geom

    EXTERN  ti_arch_byte
    EXTERN  ti_arch_inc
    EXTERN  ti_arch_add

ti_geom:
    push    af
    ld      hl, de
    ld      a, b
    or      a
    jr      z, tg_ram
    call    arch_span
    jr      nc, tg_body
    pop     af
    scf
    ret

tg_ram:
    pop     af
    push    af
    push    hl
    TICALL  _DataSize
    pop     hl
    ld      b, 0

tg_body:
    ld      a, b
    ld      (tg_page), a
    ld      (tg_ptr), hl
    ld      (tg_total), de
    ld      c, 0
    or      a
    jr      z, tg_flags
    ld      c, TI_ARCH
tg_flags:
    ld      a, c
    ld      (tg_flagsb), a
    pop     af
    cp      RealObj
    jp      z, tg_real
    cp      CplxObj
    jp      z, tg_cplx
    cp      GDBObj
    jp      z, tg_blob
    cp      GroupObj
    jp      z, tg_blob
    cp      AppVarObj
    jp      z, tg_flex
    cp      ProgObj
    jp      z, tg_flex
    cp      StrngObj
    jp      z, tg_flex
    cp      EquObj
    jp      z, tg_flex
    cp      NewEquObj
    jp      z, tg_flex
    cp      TempProgObj
    jp      z, tg_flex
    cp      ProtProgObj
    jp      z, tg_sized
    cp      PictObj
    jp      z, tg_sized
    cp      ListObj
    jp      z, tg_list9
    cp      CListObj
    jp      z, tg_list18
    cp      MatObj
    jp      z, tg_mat
    scf
    ret

; Real and complex numbers have no size word.
tg_real:
    ld      hl, 9
    jp      tg_cap0

tg_cplx:
    ld      hl, 18
    jp      tg_cap0

tg_blob:
    ld      hl, (tg_total)

tg_cap0:
    push    hl
    ld      de, (tg_total)
    or      a
    sbc     hl, de
    pop     hl
    jr      c, tg_cap_ok
    jr      z, tg_cap_ok
    ld      h, d
    ld      l, e
tg_cap_ok:
    ld      de, (tg_ptr)
    jp      tg_out

; A size word, and InsertMem may grow the RAM variable.
tg_flex:
    ld      a, (tg_page)
    or      a
    jr      nz, tg_sized
    ld      a, (tg_flagsb)
    or      TI_GROW | TI_HSIZE
    ld      (tg_flagsb), a

tg_sized:
    call    tg_need2
    jp      c, tg_zero
    call    tg_take
    ld      h, d
    ld      l, e
    jp      tg_clamp

tg_list9:
    ld      a, 9
    jr      tg_list

tg_list18:
    ld      a, 18

tg_list:
    ld      (tg_elem), a
    call    tg_need2
    jp      c, tg_zero
    call    tg_take
    ld      a, (tg_elem)
    call    tg_mul
    jp      c, tg_max
    jp      tg_clamp

tg_mat:
    call    tg_need2
    jp      c, tg_zero
    ld      hl, (tg_ptr)
    ld      a, (tg_page)
    ld      b, a
    call    tg_u8
    ld      c, a
    call    tg_u8
    ld      (tg_ptr), hl
    push    af
    ld      a, b
    ld      (tg_page), a
    pop     af
    or      a
    jp      z, tg_bad
    cp      100
    jp      nc, tg_bad
    push    af
    ld      a, c
    or      a
    jr      z, tg_bad_pop
    cp      100
    jr      nc, tg_bad_pop
    pop     af
    ld      e, c
    ld      d, 0
    ld      b, a
    ld      hl, 0
tg_mm:
    add     hl, de
    djnz    tg_mm
    push    hl
    add     hl, hl
    jr      c, tg_mat_ov
    add     hl, hl
    jr      c, tg_mat_ov
    add     hl, hl
    jr      c, tg_mat_ov
    pop     de
    add     hl, de
    jr      c, tg_max
    jp      tg_clamp

tg_mat_ov:
    pop     de

tg_max:
    ld      hl, (tg_total)
    ld      de, 2
    or      a
    sbc     hl, de
    jr      nc, tg_max_ok
    ld      hl, 0
tg_max_ok:
    ld      de, (tg_ptr)
    jp      tg_out

tg_clamp:
    push    hl
    ld      hl, (tg_total)
    ld      de, 2
    or      a
    sbc     hl, de
    jr      nc, tg_cl2
    ld      hl, 0
tg_cl2:
    pop     de
    push    hl
    or      a
    sbc     hl, de
    pop     hl
    jr      c, tg_cl_max
    ld      h, d
    ld      l, e
tg_cl_max:
    ld      de, (tg_ptr)
    jp      tg_out

tg_zero:
    ld      hl, 0
    ld      de, (tg_ptr)
    jp      tg_out

tg_bad_pop:
    pop     af

tg_bad:
    scf
    ret

tg_out:
    push    hl
    ld      a, (tg_page)
    ld      b, a
    pop     hl
    ld      a, (tg_flagsb)
    or      a
    ret

; Carry set when the data block is shorter than a size word.
tg_need2:
    ld      hl, (tg_total)
    ld      a, h
    or      a
    jr      nz, tg_need_ok
    ld      a, l
    cp      2
    ret     c
tg_need_ok:
    or      a
    ret

; Read the size word and leave tg_ptr on the first payload byte.
; DE = word. Page is kept in tg_page.
tg_take:
    ld      hl, (tg_ptr)
    ld      a, (tg_page)
    ld      b, a
    call    tg_u16
    ld      (tg_ptr), hl
    ld      a, b
    ld      (tg_page), a
    ret

tg_u16:
    call    tg_u8
    ld      e, a
    call    tg_u8
    ld      d, a
    ret

tg_u8:
    ld      a, b
    or      a
    jr      nz, tg_u8_a
    ld      a, (hl)
    inc     hl
    ret

tg_u8_a:
    call    ti_arch_byte
    push    af
    call    ti_arch_inc
    pop     af
    ret

; DE = count, A = element size. HL = product. Carry set on overflow.
tg_mul:
    push    bc
    ld      hl, 0
    ld      b, a
tg_mul_l:
    add     hl, de
    jr      c, tg_mul_c
    djnz    tg_mul_l
    pop     bc
    or      a
    ret

tg_mul_c:
    pop     bc
    scf
    ret

; BHL = archive flag. DE = data length, BHL = first data byte.
arch_span:
    call    ti_arch_inc
    call    ti_arch_byte
    ld      e, a
    call    ti_arch_inc
    call    ti_arch_byte
    ld      d, a
    push    de
    ld      c, 7
as_nl:
    call    ti_arch_inc
    dec     c
    jr      nz, as_nl
    call    ti_arch_byte
    cp      9
    jr      nc, as_bad
    push    af
    ld      e, a
    ld      d, 0
    inc     de
    call    ti_arch_add
    pop     af
    add     a, 7
    push    hl
    push    bc
    ld      e, a
    ld      d, 0
    pop     bc
    pop     hl
    ex      (sp), hl
    or      a
    sbc     hl, de
    ex      de, hl
    pop     hl
    ret     nc
    scf
    ret

as_bad:
    pop     de
    scf
    ret

    SECTION bss_clib

tg_total:
    defw    0

tg_ptr:
    defw    0

tg_page:
    defb    0

tg_flagsb:
    defb    0

tg_elem:
    defb    0

ENDIF
