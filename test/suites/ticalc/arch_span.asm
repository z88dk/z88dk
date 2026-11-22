; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Host proof for an archived ti_geom address and the 17-byte slot stride.
; The rst 28h stub stands in for LoadCIndPaged. There is no ROM.
; Linked at 8000h. The +test CRT owns address 0, and the archive window
; is 4000h-7FFFh.

    SECTION code_clib

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    EXTERN  ti_geom
    EXTERN  ti_slot
    EXTERN  ti_files

    PUBLIC  tiei
    PUBLIC  tidi
    PUBLIC  pass

start:
    di
    ld      sp, $fffe
    ld      hl, bcall
    ld      de, $28
    ld      bc, bcall_end - bcall
    ldir

    ld      hl, real_img
    ld      de, $4000
    ld      bc, real_img_end - real_img
    ldir
    ld      a, RealObj
    ld      b, 5
    ld      de, $4000
    call    call_geom
    ld      de, exp_real
    call    match

    ld      hl, app_img
    ld      de, $4100
    ld      bc, app_img_end - app_img
    ldir
    ld      a, AppVarObj
    ld      b, 5
    ld      de, $4100
    call    call_geom
    ld      de, exp_app
    call    match

    ld      hl, list_img
    ld      de, $4201
    ld      bc, list_img_end - list_img
    ldir
    ld      a, ListObj
    ld      b, 5
    ld      de, $4201
    call    call_geom
    ld      de, exp_list
    call    match

    ; A fixed entry crosses onto a page that is not a sector start.
    ld      a, 18
    ld      ($7ff9), a
    xor     a
    ld      ($7ff8), a
    ld      ($7ffa), a
    ld      a, RealObj
    ld      b, 5
    ld      de, $7ff8
    call    call_geom
    ld      de, exp_real_x
    call    match

    ; The same shape onto a sector start. 4000h on that page is a status byte.
    ld      a, 18
    ld      ($7ff9), a
    xor     a
    ld      ($7ff8), a
    ld      ($7ffa), a
    ld      a, RealObj
    ld      b, 7
    ld      de, $7ff8
    call    call_geom
    ld      de, exp_real_s
    call    match

    ; The name length is the last byte of the page. The payload is on the next page.
    ld      a, 13
    ld      ($7ff7), a
    xor     a
    ld      ($7ff6), a
    ld      ($7ff8), a
    ld      a, 2
    ld      ($7fff), a
    ld      ($4003), a
    xor     a
    ld      ($4004), a
    ld      a, AppVarObj
    ld      b, 7
    ld      de, $7ff6
    call    call_geom
    ld      de, exp_app_s
    call    match

    ; The size word is the header length, so the file length is 0.
    ld      a, 9
    ld      ($4701), a
    xor     a
    ld      ($4700), a
    ld      ($4702), a
    ld      a, RealObj
    ld      b, 5
    ld      de, $4700
    call    call_geom
    ld      de, exp_real_0
    call    match

    ; A size word shorter than a fixed header sets carry.
    ld      a, 4
    ld      ($4501), a
    xor     a
    ld      ($4500), a
    ld      ($4502), a
    ld      a, RealObj
    ld      b, 5
    ld      de, $4500
    call    call_carry

    ; A name length of 9 is rejected before a payload address is formed.
    ld      a, 20
    ld      ($4601), a
    xor     a
    ld      ($4600), a
    ld      ($4602), a
    ld      a, 9
    ld      ($4609), a
    ld      a, AppVarObj
    ld      b, 5
    ld      de, $4600
    call    call_carry

    ld      hl, ti_files
    ld      b, TI_NSLOTS * TI_SLOT
    xor     a
slot_z:
    ld      (hl), a
    inc     hl
    djnz    slot_z
    ld      hl, ti_files
    ld      de, fs_flags
    add     hl, de
    ld      (hl), TI_OPEN
    ld      hl, ti_files
    ld      de, 7 * TI_SLOT + fs_flags
    add     hl, de
    ld      (hl), TI_OPEN

    ld      a, 3
    call    ti_slot
    call    c, fail
    ld      de, ti_files
    or      a
    sbc     hl, de
    call    nz, fail

    ld      a, 10
    call    ti_slot
    call    c, fail
    ld      de, ti_files
    or      a
    sbc     hl, de
    ld      de, 7 * TI_SLOT
    or      a
    sbc     hl, de
    call    nz, fail

    ld      a, 4
    call    ti_slot
    call    nc, fail
    ld      a, 2
    call    ti_slot
    call    nc, fail
    ld      a, 11
    call    ti_slot
    call    nc, fail

    ld      a, (fails)
    or      a
    jr      z, say_ok
    ld      hl, msg_no
    jr      say
say_ok:
    ld      hl, msg_ok
say:
    ld      a, (hl)
    or      a
    jr      z, say_nl
    out     (1), a
    inc     hl
    jr      say
say_nl:
    ld      a, 10
    out     (1), a
pass:
    halt

msg_ok:
    defm    "arch-ok", 0
msg_no:
    defm    "arch-no", 0

; In: A = type, B = page, DE = flag. The record is L, H, E, D, B, A, carry.
call_geom:
    ld      (sp0), sp
    call    ti_geom
    push    af
    push    bc
    push    de
    push    hl
    ld      hl, (sp0)
    or      a
    sbc     hl, sp
    ld      a, l
    cp      8
    call    nz, fail
    ld      hl, (rp)
    ld      (last), hl
    pop     de
    ld      (hl), e
    inc     hl
    ld      (hl), d
    inc     hl
    pop     de
    ld      (hl), e
    inc     hl
    ld      (hl), d
    inc     hl
    pop     bc
    ld      (hl), b
    inc     hl
    pop     af
    ld      (hl), a
    inc     hl
    ld      a, 0
    jr      nc, cg_nc
    inc     a
cg_nc:
    ld      (hl), a
    inc     hl
    ld      (rp), hl
    ret

call_carry:
    call    call_geom
    ld      hl, (last)
    ld      de, 6
    add     hl, de
    ld      a, (hl)
    cp      1
    call    nz, fail
    ret

; DE = seven expected bytes.
match:
    ld      hl, (last)
    ld      b, 7
match_b:
    ld      a, (de)
    cp      (hl)
    call    nz, fail
    inc     de
    inc     hl
    djnz    match_b
    ret

fail:
    push    af
    ld      a, (fails)
    inc     a
    ld      (fails), a
    pop     af
    ret

tiei:
    ei
    ret

tidi:
    ret

bcall:
    pop     de
    inc     de
    inc     de
    push    de
    ld      c, (hl)
    ret
bcall_end:

real_img:
    defb    0, 18, 0
    defs    16, 0
real_img_end:

app_img:
    defb    0, 13, 0
    defs    6, 0
    defb    2, 'A', 'B', 2, 0, $aa, $bb
app_img_end:

list_img:
    defb    0, 20, 0
    defs    6, 0
    defb    1, $5b, 0, 1, 0
    defs    9, $22
list_img_end:

exp_real:
    defb    9, 0, $0c, $40, 5, 8, 0
exp_app:
    defb    2, 0, $0e, $41, 5, 8, 0
exp_list:
    defb    9, 0, $0f, $42, 5, 8, 0
exp_real_x:
    defb    9, 0, $04, $40, 6, 8, 0
exp_real_s:
    defb    9, 0, $05, $40, 8, 8, 0
exp_app_s:
    defb    2, 0, $05, $40, 8, 8, 0
exp_real_0:
    defb    0, 0, $0c, $47, 5, 8, 0

    SECTION bss_clib

sp0:
    defw    0
rp:
    defw    report
last:
    defw    0
fails:
    defb    0
report:
    defs    16 * 7
