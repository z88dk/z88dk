; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
; Turn a C string into an OP1 name.
;
; A bare name is an AppVar. "X:rest" selects a type:
;   A AppVar  P program  R real  C complex  L list  M matrix
;   E equation  S string  I picture  G graph database  O group
; Program and AppVar names are the tokens themselves.
; Predefined L1-L6, [A]-[J], Y1-Y0, Str1, Pic1 and GDB1 use OS tokens.

IF FORti83p

    INCLUDE "Ti83p.def"
    INCLUDE "target/ticalc/fcntl/ti_fcntl.inc"

    SECTION code_clib

    PUBLIC  ti_name

; HL = C string. OP1 is filled. A = type. Carry set when the name is rejected.
ti_name:
    ld      a, (hl)
    or      a
    jp      z, tn_bad
    inc     hl
    ld      a, (hl)
    dec     hl
    cp      ':'
    jr      z, tn_typed
    ld      a, AppVarObj
    call    op1_prepare
    call    copy_raw
    jp      c, tn_bad
    call    raw_ok
    jp      c, tn_bad
    ld      a, AppVarObj
    or      a
    ret

tn_typed:
    ld      a, (hl)
    call    up_a
    inc     hl
    inc     hl
    push    af
    ld      a, (hl)
    or      a
    jr      z, tn_pop_bad
    pop     af
    cp      'A'
    jp      z, tn_app
    cp      'P'
    jp      z, tn_prog
    cp      'R'
    jp      z, tn_real
    cp      'C'
    jp      z, tn_cplx
    cp      'L'
    jp      z, tn_list
    cp      'M'
    jp      z, tn_mat
    cp      'E'
    jp      z, tn_equ
    cp      'S'
    jp      z, tn_str
    cp      'I'
    jp      z, tn_pic
    cp      'G'
    jp      z, tn_gdb
    cp      'O'
    jp      z, tn_grp
    jp      tn_bad

tn_pop_bad:
    pop     af
tn_bad:
    scf
    ret

tn_app:
    ld      a, AppVarObj
    jr      tn_raw
tn_prog:
    ld      a, ProgObj
    jr      tn_raw
tn_grp:
    ld      a, GroupObj
tn_raw:
    call    op1_prepare
    call    copy_raw
    jp      c, tn_bad
    call    raw_ok
    jp      c, tn_bad
    ld      a, (OP1)
    or      a
    ret

tn_real:
    ld      a, RealObj
    call    op1_prepare
    call    real_name
    jp      c, tn_bad
    ld      a, RealObj
    or      a
    ret

tn_cplx:
    ld      a, CplxObj
    call    op1_prepare
    call    real_name
    jp      c, tn_bad
    ld      a, CplxObj
    or      a
    ret

tn_list:
    ld      a, ListObj
    call    op1_prepare
    call    list_name
    jp      c, tn_bad
    ld      a, ListObj
    or      a
    ret

tn_mat:
    ld      a, MatObj
    call    op1_prepare
    call    mat_name
    jp      c, tn_bad
    ld      a, MatObj
    or      a
    ret

tn_equ:
    ld      a, EquObj
    call    op1_prepare
    call    equ_name
    jp      c, tn_bad
    ld      a, EquObj
    or      a
    ret

tn_str:
    ld      a, StrngObj
    ld      b, 'S'
    ld      c, 'R'
    jp      tn_sys
tn_pic:
    ld      a, PictObj
    ld      b, 'P'
    ld      c, 'C'
    jp      tn_sys
tn_gdb:
    ld      a, GDBObj
    ld      b, 'G'
    ld      c, 'B'

; A = type. B = first prefix letter, C = third. The middle letter is 'T' for Str,
; 'I' for Pic and 'D' for GDB, checked below from the type.
tn_sys:
    push    bc
    call    op1_prepare
    pop     bc
    ld      a, (OP1)
    cp      StrngObj
    ld      a, tVarStrng
    jr      z, tn_sys2
    ld      a, (OP1)
    cp      PictObj
    ld      a, tVarPict
    jr      z, tn_sys2
    ld      a, tVarGDB
tn_sys2:
    ld      (OP1+1), a
    call    sys_index
    jp      c, tn_bad
    ld      a, (OP1)
    or      a
    ret

; HL = name. OP1 is clear except the type. Carry set on a bad token.
op1_prepare:
    push    af
    call    op1_clear
    pop     af
    ld      (OP1), a
    ret

op1_clear:
    push    hl
    push    bc
    ld      hl, OP1
    ld      b, 9
oc_loop:
    ld      (hl), 0
    inc     hl
    djnz    oc_loop
    pop     bc
    pop     hl
    ret

; Copy up to 8 name bytes. A ninth byte is rejected.
copy_raw:
    ld      de, OP1+1
    ld      b, 8
cr_loop:
    ld      a, (hl)
    or      a
    ret     z
    ld      (de), a
    inc     hl
    inc     de
    djnz    cr_loop
    ld      a, (hl)
    or      a
    ret     z
    scf
    ret

; First token is A-Z or theta. Each later token is A-Z, theta, or a digit.
raw_ok:
    ld      hl, OP1+1
    call    tok_lead
    ret     c
ro_more:
    inc     hl
    ld      a, (hl)
    or      a
    ret     z
    call    tok_body
    ret     c
    jr      ro_more

tok_lead:
    ld      a, (hl)
    or      a
    scf
    ret     z
    cp      $5b
    ret     z
    cp      'A'
    ret     c
    cp      'Z'+1
    ccf
    ret

tok_body:
    cp      $5b
    ret     z
    cp      '0'
    jr      c, tb_no
    cp      '9'+1
    jr      c, tb_yes
    cp      'A'
    ret     c
    cp      'Z'+1
    ccf
    ret

tb_yes:
    or      a
    ret

tb_no:
    scf
    ret

; One letter, A-Z or the theta token.
real_name:
    ld      a, (hl)
    cp      $5b
    jr      z, rn_ok
    call    up_a
    cp      'A'
    ret     c
    cp      'Z'+1
    ccf
    ret     c
rn_ok:
    ld      (OP1+1), a
    inc     hl
    ld      a, (hl)
    or      a
    scf
    ret     nz
    or      a
    ret

list_name:
    push    hl
    call    peek_up
    cp      'L'
    jr      nz, ln_user
    inc     hl
    call    take_digit
    jr      c, ln_user
    ld      a, c
    cp      6
    jr      nc, ln_user
    ld      a, (hl)
    or      a
    jr      nz, ln_user
    ld      a, c
    pop     hl
    ld      (OP1+2), a
    ld      a, tVarLst
    ld      (OP1+1), a
    or      a
    ret

ln_user:
    pop     hl
    ld      a, tVarLst
    ld      (OP1+1), a
    ld      de, OP1+2
    ld      b, 5
ln_copy:
    ld      a, (hl)
    or      a
    jr      z, ln_lead
    ld      (de), a
    inc     hl
    inc     de
    djnz    ln_copy
    ld      a, (hl)
    or      a
    scf
    ret     nz
ln_lead:
    ld      hl, OP1+2
    call    tok_lead
    ret     c
ln_rest:
    inc     hl
    ld      a, (hl)
    or      a
    ret     z
    call    tok_body
    ret     c
    jr      ln_rest

mat_name:
    call    peek_up
    cp      '['
    jr      nz, mn_let
    inc     hl
mn_let:
    call    peek_up
    cp      'A'
    ret     c
    cp      'J'+1
    ccf
    ret     c
    sub     'A'
    ld      (OP1+2), a
    ld      a, tVarMat
    ld      (OP1+1), a
    inc     hl
    call    peek_up
    cp      ']'
    jr      nz, mn_end
    inc     hl
mn_end:
    ld      a, (hl)
    or      a
    scf
    ret     nz
    or      a
    ret

equ_name:
    call    peek_up
    inc     hl
    cp      'Y'
    jr      z, en_y
    cp      'X'
    jr      z, en_x
    cp      'R'
    jr      z, en_r
    cp      'U'
    ld      c, tun
    jr      z, en_one
    cp      'V'
    ld      c, tvn
    jr      z, en_one
    cp      'W'
    ld      c, twn
    jr      z, en_one
    scf
    ret

; E:U and E:U(n) are the same equation. V and W match that pair.
en_one:
    ld      a, (hl)
    or      a
    jr      z, en_bare
    cp      '('
    scf
    ret     nz
    inc     hl
    call    peek_up
    cp      'N'
    scf
    ret     nz
    inc     hl
    ld      a, (hl)
    cp      ')'
    scf
    ret     nz
    inc     hl
    ld      a, (hl)
    or      a
    scf
    ret     nz
en_bare:
    ld      a, c
    jr      en_store

en_y:
    call    take_digit
    ret     c
    ld      a, (hl)
    or      a
    jr      z, en_y_plain
    call    up_a
    cp      'T'
    scf
    ret     nz
    inc     hl
    ld      a, (hl)
    or      a
    scf
    ret     nz
    ld      a, c
    cp      6
    ccf
    ret     c
    add     a, a
    add     a, tY1T
    jr      en_store

en_y_plain:
    ld      a, tY1
    add     a, c
    jr      en_store

en_x:
    call    take_digit
    ret     c
    ld      a, c
    cp      6
    ccf
    ret     c
    add     a, a
    add     a, tX1T
    ld      c, a
    call    need_t
    ret     c
    ld      a, c
    jr      en_store

en_r:
    call    take_digit
    ret     c
    ld      a, c
    cp      6
    ccf
    ret     c
    add     a, tR1
    ld      c, a
    ld      a, (hl)
    or      a
    ld      a, c
    scf
    ret     nz
    or      a

en_store:
    ld      (OP1+2), a
    ld      a, tVarEqu
    ld      (OP1+1), a
    or      a
    ret

; B = first letter, C = third letter. "STR" / "PIC" / "GDB", or a bare digit.
sys_index:
    call    peek_up
    cp      b
    jr      nz, one_index
    inc     hl
    ld      a, (OP1)
    cp      PictObj
    jr      z, si_pic
    cp      GDBObj
    jr      z, si_gdb
    call    peek_up
    cp      'T'
    jr      si_mid
si_pic:
    call    peek_up
    cp      'I'
    jr      si_mid
si_gdb:
    call    peek_up
    cp      'D'
si_mid:
    scf
    ret     nz
    inc     hl
    call    peek_up
    cp      c
    scf
    ret     nz
    inc     hl
one_index:
    call    take_digit
    ret     c
    ld      a, (hl)
    or      a
    scf
    ret     nz
    ld      a, c
    ld      (OP1+2), a
    or      a
    ret

need_t:
    call    peek_up
    cp      'T'
    scf
    ret     nz
    inc     hl
    ld      a, (hl)
    or      a
    scf
    ret     nz
    or      a
    ret

; (HL) is a digit. C = 0 for '1' ... 8 for '9', 9 for '0'. HL advances.
take_digit:
    ld      a, (hl)
    inc     hl
    cp      '0'
    jr      z, td_zero
    cp      '1'
    ret     c
    cp      '9'+1
    ccf
    ret     c
    sub     '1'
    ld      c, a
    or      a
    ret
td_zero:
    ld      c, 9
    or      a
    ret

peek_up:
    ld      a, (hl)
up_a:
    cp      'a'
    ret     c
    cp      'z'+1
    ret     nc
    and     $df
    ret

ENDIF
