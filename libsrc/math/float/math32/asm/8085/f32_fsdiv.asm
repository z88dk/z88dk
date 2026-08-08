;
;  feilipu, 2026 August
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32_fsdiv — 8085 restoring IEEE single divide
;-------------------------------------------------------------------------
;
; Stack-only (no exx / IX / djnz / bit).  Restoring step after l_long_div_0:
;   rem/div/quot on stack; trial via A sub/sbc; ld de,sp+* traffic.
;
; Entry:
;   m32_fsdiv        DEHL = b; stack = ret, a [, b]
;   m32_fsdiv_callee DEHL = b; stack = ret, a   (drops a)
;
; Work (14) under [sign][a][b][flag][ret]:
;   +0..+3 rem   +4..+6 div   +8..+10 quot   +12 expR
;
; Result DEHL = a / b.
;
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsconst_nzero, m32_fsconst_pzero
EXTERN m32_fsconst_ninf, m32_fsconst_pinf, m32_fsconst_pnan

PUBLIC m32_fsdiv, m32_fsdiv_callee


.m32_fsdiv
    xor a
    jp dv_go

.m32_fsdiv_callee
    ld a,1

.dv_go
    ld b,0
    ld c,a
    push bc                     ; flag

    push de
    push hl                     ; b
    ld de,sp+8
    call get4                   ; a
    push de
    push hl                     ; a

    ld de,sp+3
    ld a,(de)
    ld de,sp+7
    ld l,a
    ld a,(de)
    xor l
    and 080h
    ld l,a
    ld h,0
    push hl                     ; sign

    ld hl,-14
    add hl,sp
    ld sp,hl
    ; work+0  sign+14  a+16  b+20  flag+24  ret+26

    ld de,sp+16
    call get4
    call cls
    cp 3
    jp Z,x_nan
    cp 2
    jp Z,x_ainf
    or a
    jp Z,x_azero
    ld de,sp+20
    call get4
    call cls
    cp 3
    jp Z,x_nan
    cp 2
    jp Z,x_binf
    or a
    jp Z,x_bzero
    ld de,sp+16
    call get4
    call unp                    ; B=exp_a A=mhi HL=mlo
    ld de,sp+12
    push af
    ld a,b
    ld (de),a
    pop af
    ld de,sp+0
    ld (de),l
    inc de
    ld (de),h
    inc de
    ld (de),a
    inc de
    xor a
    ld (de),a

    ld de,sp+20
    call get4
    call unp                    ; B=exp_b A=mhi HL=mlo
    ld de,sp+4
    ld (de),l
    inc de
    ld (de),h
    inc de
    ld (de),a

    ld de,sp+12
    ld a,(de)
    sub b
    ld e,a
    ld d,0
    jp NC,ep_ok
    ld d,0ffh
.ep_ok
    ld hl,127
    add hl,de
    ld a,h
    or a
    jp NZ,x_expbad
    ld a,l
    cp 255
    jp NC,x_of
    or a
    jr NZ,eok
    inc a
.eok
    ld de,sp+12
    ld (de),a

    ld de,sp+8
    xor a
    ld (de),a
    inc de
    ld (de),a
    inc de
    ld (de),a

    call rem_lt_div
    jr NC,pre_ok
    call rem_shl
    ld de,sp+12
    ld a,(de)
    dec a
    ld (de),a
.pre_ok

    ld b,24
.lp
    call rem_try
    jr C,q0
    call quot_bit1
    jr qdone

.q0
    call rem_add
    call quot_bit0
.qdone
    call rem_shl
    dec b
    jp NZ,lp
    call rem_try
    jr C,g_rest
    call rem_nz
    jr NZ,g_up
    ld de,sp+8
    ld a,(de)
    and 1
    jr Z,g_done
.g_up
    call quot_inc
    jr g_done

.g_rest
    call rem_add
.g_done

    ; B=qhi, HL = qmid:qlo (avoid partial DE updates)
    ld de,sp+10
    ld a,(de)
    ld b,a                      ; qhi
    ld de,sp+8
    ld a,(de)
    ld l,a                      ; qlo
    inc de
    ld a,(de)
    ld h,a                      ; qmid

    ld a,b
    or a
    rla
    jr C,pack
    add hl,hl
    ld a,b
    rla
    ld b,a
    ld de,sp+12
    ld a,(de)
    dec a
    ld (de),a
.pack
    ld de,sp+12
    ld a,(de)                   ; expR
    or a
    jp Z,x_uflow
    cp 255
    jp NC,x_of
    ld c,a                      ; exp
    ld a,b
    and 07fh
    ld b,a
    ld a,c
    and 1
    jr Z,pk0
    ld a,b
    or 080h
    ld b,a
.pk0
    ld a,c
    and 0feh
    rra                         ; exp >> 1
    ld c,a
    ld de,sp+14
    ld a,(de)                   ; sign
    and 080h
    or c
    ; A = sign|exp>>1, B = mhi, HL = mid:lo
    ld d,a
    ld e,b
    ; DEHL = IEEE

    ; free work/sign/a/b/flag; callee may drop a under ret
    ; BC free: park high in BC, low in HL already as H:L of IEEE? 
    ; IEEE DEHL: D,E,H,L — high word DE, low word HL.
    ld bc,de                    ; BC = high
    ; HL already low
    ex de,hl                    ; DE = low, HL free for SP
    ld hl,14
    add hl,sp
    ld sp,hl                    ; free work; BC=high DE=low
    pop af                      ; sign
    pop af
    pop af                      ; a copy
    pop af
    pop af                      ; b copy
    pop hl                      ; flag in L (word was B=0 C=flag → L=flag)
    ld a,l
    ld hl,de                    ; HL = low
    ld de,bc                    ; DE = high → DEHL = result
    or a
    jr Z,done_nc
    pop bc                      ; ret
    pop af
    pop af                      ; drop original a
    push bc
.done_nc
    ret

;--------------------------------------------------------------------
.get4
    ld hl,de
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)
    ld hl,bc
    ret

.cls
    ld a,d
    and 07fh
    cp 07fh
    jr Z,cls_hi
    ld a,d
    and 07fh
    or e
    or h
    or l
    ld a,0
    ret Z
    ld a,1
    ret
.cls_hi
    ld a,e
    and 07fh
    or h
    or l
    ld a,2
    ret Z
    ld a,3
    ret

; DEHL IEEE → B=exp, A=mhi, HL=mlo
.unp
    ex de,hl                    ; HL = D:E, DE = H:L (mlo)
    add hl,hl                   ; H=exp, L=top mant bits
    ld b,h                      ; B = exp
    ld a,b
    or a
    ld a,l
    jr Z,unp0
    scf
    rra                         ; A = mhi with implicit 1
    ex de,hl                    ; HL = mlo
    ret
.unp0
    and 07fh
    ex de,hl
    ret

;--------------------------------------------------------------------
; Stack helpers — called, so work base is sp+2 (ret at +0), like l_long_div_0.
; work: rem+2 div+6 quot+10 expR+14
;--------------------------------------------------------------------

.rem_shl
    ld de,sp+2
    ld a,(de)
    add a,a
    ld (de),a
    inc de
    ld a,(de)
    rla
    ld (de),a
    inc de
    ld a,(de)
    rla
    ld (de),a
    inc de
    ld a,(de)
    rla
    ld (de),a
    ret

.rem_lt_div
    ld de,sp+5
    ld a,(de)
    or a
    jr NZ,rlt_nc
    ld de,sp+4
    ld a,(de)
    ld c,a
    ld de,sp+8
    ld a,(de)
    cp c
    jr C,rlt_nc
    jr NZ,rlt_c
    ld de,sp+3
    ld a,(de)
    ld c,a
    ld de,sp+7
    ld a,(de)
    cp c
    jr C,rlt_nc
    jr NZ,rlt_c
    ld de,sp+2
    ld a,(de)
    ld c,a
    ld de,sp+6
    ld a,(de)
    cp c
    jr C,rlt_nc
    jr Z,rlt_nc
.rlt_c
    scf
    ret
.rlt_nc
    or a
    ret

.rem_try
    ld de,sp+6
    ld a,(de)
    ld c,a
    ld de,sp+2
    ld a,(de)
    sub c
    ld (de),a
    ld de,sp+7
    ld a,(de)
    ld c,a
    ld de,sp+3
    ld a,(de)
    sbc a,c
    ld (de),a
    ld de,sp+8
    ld a,(de)
    ld c,a
    ld de,sp+4
    ld a,(de)
    sbc a,c
    ld (de),a
    ld de,sp+5
    ld a,(de)
    sbc a,0
    ld (de),a
    ret

.rem_add
    ld de,sp+6
    ld a,(de)
    ld c,a
    ld de,sp+2
    ld a,(de)
    add a,c
    ld (de),a
    ld de,sp+7
    ld a,(de)
    ld c,a
    ld de,sp+3
    ld a,(de)
    adc a,c
    ld (de),a
    ld de,sp+8
    ld a,(de)
    ld c,a
    ld de,sp+4
    ld a,(de)
    adc a,c
    ld (de),a
    ld de,sp+5
    ld a,(de)
    adc a,0
    ld (de),a
    ret

.rem_nz
    ld de,sp+2
    ld a,(de)
    inc de
    ld c,a
    ld a,(de)
    or c
    ld c,a
    inc de
    ld a,(de)
    or c
    ld c,a
    inc de
    ld a,(de)
    or c
    ret

.quot_bit0
    ld de,sp+10
    ld a,(de)
    add a,a                     ; C = old b7
    ld (de),a
    inc de
    ld a,(de)
    rla
    ld (de),a
    inc de
    ld a,(de)
    rla
    ld (de),a
    ret

.quot_bit1
    ; or 1 clears C — save carry from add a,a before setting bit0
    ld de,sp+10
    ld a,(de)
    add a,a
    push af                     ; save C from shift
    or 1
    ld (de),a
    inc de
    pop af                      ; restore C
    ld a,(de)
    rla
    ld (de),a
    inc de
    ld a,(de)
    rla
    ld (de),a
    ret

.quot_inc
    ld de,sp+10
    ld a,(de)
    inc a
    ld (de),a
    ret NZ
    inc de
    ld a,(de)
    inc a
    ld (de),a
    ret NZ
    inc de
    ld a,(de)
    inc a
    ld (de),a
    ret NZ
    ld a,080h
    ld (de),a
    ld de,sp+14
    ld a,(de)
    inc a
    ld (de),a
    ret

;--------------------------------------------------------------------
; Specials: SP → work (no extra ret).  sign@+14 a@+16 b@+20 flag@+24
;--------------------------------------------------------------------
.x_nan
    xor a
    ld c,a                      ; sign unused
    call drop_frame
    jp m32_fsconst_pnan

.x_ainf
    ld de,sp+20
    call get4
    call cls
    cp 2
    jp Z,x_nan
    cp 3
    jp Z,x_nan
    ld de,sp+14
    ld a,(de)
    ld c,a                      ; sign
    call drop_frame
    jp to_inf

.x_azero
    ld de,sp+20
    call get4
    call cls
    or a
    jp Z,x_nan
    ld de,sp+14
    ld a,(de)
    ld c,a
    call drop_frame
    jp to_zero

.x_binf
    ld de,sp+14
    ld a,(de)
    ld c,a
    call drop_frame
    jp to_zero

.x_bzero
    ld de,sp+14
    ld a,(de)
    ld c,a
    call drop_frame
    jp to_inf

.x_expbad
    ld a,h
    rla
    jp C,x_uflow
.x_of
    ld de,sp+14
    ld a,(de)
    ld c,a
    call drop_frame
    jp to_inf

.x_uflow
    ld de,sp+14
    ld a,(de)
    ld c,a
    call drop_frame
    jp to_zero

; SP on entry to drop_frame = work (via CALL → ret@+0, work@+2).
; Drops ret+work+sign+a+b+flag.  Preserves C (sign).  Callee drops a under ret.
.drop_frame
    ld hl,16                    ; ret + work
    add hl,sp
    ld sp,hl                    ; → sign
    pop af                      ; sign
    pop af
    pop af                      ; a
    pop af
    pop af                      ; b
    pop de                      ; flag in E
    ld a,e
    or a
    ret Z
    pop de                      ; ret
    pop af
    pop af                      ; drop a
    push de
    ret

.to_inf
    ld a,c
    rla
    jp C,m32_fsconst_ninf
    jp m32_fsconst_pinf

.to_zero
    ld a,c
    rla
    jp C,m32_fsconst_nzero
    jp m32_fsconst_pzero
