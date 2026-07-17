;
;  feilipu, 2026 July
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;

;-------------------------------------------------------------------------
; m32_fsadd / m32_fssub - 8085 IEEE single add/sub
;-------------------------------------------------------------------------
; Slot: +0 L=MSB +1 H=0 +2 E=LSB +3 D=mid +4 exp +5 sign
;-------------------------------------------------------------------------

SECTION code_clib
SECTION code_fp_math32

EXTERN m32_fsnormalize

PUBLIC m32_fssub, m32_fssub_callee
PUBLIC m32_fsadd, m32_fsadd_callee


.m32_fssub
    ld a,d
    xor 080h
    ld d,a
.m32_fsadd
    xor a
    jp fa_start

.m32_fssub_callee
    ld a,d
    xor 080h
    ld d,a
.m32_fsadd_callee
    ld a,1


.fa_start
    push af
    call unpack_push
    ld de,sp+10
    call load_ieee
    call unpack_push
    ld de,sp+4
    ld a,(de)
    ld b,a
    ld de,sp+10
    ld a,(de)
    ld c,a
    ld a,c
    cp b
    call NC,swap6

    ld de,sp+4
    ld a,(de)
    ld b,a
    ld de,sp+10
    ld a,(de)
    ld c,a
    ld a,b
    sub c
    ; before align dump X exp
    ld de,sp+4
    ld a,(de)
    call align_y
    ld de,sp+4
    ld a,(de)
    ld de,sp+6
    ld a,(de)

    ld de,sp+5
    ld a,(de)
    ld b,a
    ld de,sp+11
    ld a,(de)
    xor b
    and 080h
    jp NZ,do_sub

    call mant_add
    or a
    jp Z,pack_x
    call mant_shr1
    ld de,sp+4
    ld a,(de)
    inc a
    ld (de),a
    jp Z,ovf
    jp pack_x

.do_sub
    call mant_sub
    call mant_zero
    jp Z,ret0
    call load_x_regs
    call m32_fsnormalize
    jp epi

.pack_x
    call load_x_regs
    ld h,0
    add hl,hl
    ld h,c
    ld a,b
    rla
    ld a,h
    rra
    ld h,a
    ld a,l
    rra
    ld l,a
    ex de,hl
    jp epi

.ovf
    ld de,sp+5
    ld a,(de)
    and 080h
    or 07fh
    ld d,a
    ld e,080h
    ld hl,0
    scf
    jp epi

.ret0
    ld de,sp+5
    ld a,(de)
    and 080h
    ld d,a
    ld e,0
    ld h,e
    ld l,e

.epi
    push de
    push hl
    ld de,sp+16
    ld a,(de)
    pop hl
    pop de
    ld c,a
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af
    pop af
    ld a,c
    or a
    jp Z,done
    pop bc
    pop af
    pop af
    push bc
.done
    ret


;------------------------------------------------------------------------------

.unpack_push
    call unpack_dehl
    ld a,l
    pop hl
    push bc
    push de
    ld b,h
    ld c,l
    ld l,a
    ld h,0
    push hl
    push bc
    ret


.unpack_dehl
    ex de,hl
    ld a,h
    ld b,a
    add hl,hl
    ld c,h
    ld a,h
    or a
    jp Z,un0
    scf
.un0
    ld a,l
    rra
    ld l,a
    ld h,0
    ret



.swap6
    pop hl
    ld (swap_ret),hl
    pop hl
    ld (swap_x0),hl
    pop hl
    ld (swap_x1),hl
    pop hl
    ld (swap_x2),hl
    pop hl
    ld (swap_y0),hl
    pop hl
    ld (swap_y1),hl
    pop hl
    ld (swap_y2),hl
    ld hl,(swap_x2)
    push hl
    ld hl,(swap_x1)
    push hl
    ld hl,(swap_x0)
    push hl
    ld hl,(swap_y2)
    push hl
    ld hl,(swap_y1)
    push hl
    ld hl,(swap_y0)
    push hl
    ld hl,(swap_ret)
    push hl
    ret


; Align Y at +6 by A right shifts

.align_y
    or a
    ret Z
    cp 24
    jp C,aygo
    ld hl,0
    add hl,sp
    ld de,6
    add hl,de
    ld a,(hl)
    push hl
    inc hl
    inc hl
    or (hl)
    inc hl
    or (hl)
    pop hl
    push af
    xor a
    ld (hl),a
    inc hl
    ld (hl),a
    inc hl
    ld (hl),a
    pop af
    ret Z
    dec hl
    dec hl
    ld a,1
    ld (hl),a
    ret


.aygo
    ld b,a
.aylp
    ; align_y called via CALL so ret is on stack; X at +2, Y at +8.
    ; After push bc: Y at +10.
    push bc
    ld hl,0
    add hl,sp
    ld de,10
    add hl,de
    ld a,(hl)
    ld e,a                      ; MSB
    inc hl
    inc hl
    ld a,(hl)
    ld d,a                      ; LSB
    inc hl
    ld a,(hl)
    ld c,a                      ; mid
    ld a,d
    and 01h
    ld b,a
    ld a,e
    or a
    rra
    ld e,a
    ld a,c
    rra
    ld c,a
    ld a,d
    rra
    or b
    ld d,a                      ; E=MSB D=LSB C=mid after next fix
    ; Actually E=MSB, D=LSB shifted, C=mid shifted
    ld a,e                      ; MSB to A
    ld hl,0
    add hl,sp
    push de
    push bc
    ld de,10
    add hl,de
    pop bc
    pop de
    ld (hl),a                   ; MSB
    inc hl
    inc hl
    ld a,d
    ld (hl),a                   ; LSB
    inc hl
    ld a,c
    ld (hl),a                   ; mid
    pop bc
    dec b
    jp NZ,aylp
    ret


.mant_add
    ld de,sp+2
    ld a,(de)
    ld de,sp+8
    push af
    ld a,(de)
    ld h,a
    pop af
    add a,h
    ld de,sp+2
    ld (de),a
    ld de,sp+3
    ld a,(de)
    ld de,sp+9
    push af
    ld a,(de)
    ld h,a
    pop af
    adc a,h
    ld de,sp+3
    ld (de),a
    ld de,sp+0
    ld a,(de)
    ld de,sp+6
    push af
    ld a,(de)
    ld h,a
    pop af
    adc a,h
    ld de,sp+0
    ld (de),a
    ld a,0
    rla
    ret


.mant_sub
    ; compare x vs y MSB first
    ld de,sp+0
    ld a,(de)
    ld de,sp+6
    push af
    ld a,(de)
    ld h,a
    pop af
    cp h
    jp C,ms_rev
    jp NZ,ms_do
    ld de,sp+3
    ld a,(de)
    ld de,sp+9
    push af
    ld a,(de)
    ld h,a
    pop af
    cp h
    jp C,ms_rev
    jp NZ,ms_do
    ld de,sp+2
    ld a,(de)
    ld de,sp+8
    push af
    ld a,(de)
    ld h,a
    pop af
    cp h
    jp C,ms_rev
.ms_do
    ld de,sp+2
    ld a,(de)
    ld de,sp+8
    push af
    ld a,(de)
    ld h,a
    pop af
    sub h
    ld de,sp+2
    ld (de),a
    ld de,sp+3
    ld a,(de)
    ld de,sp+9
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+3
    ld (de),a
    ld de,sp+0
    ld a,(de)
    ld de,sp+6
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+0
    ld (de),a
    ret
.ms_rev
    ld de,sp+8
    ld a,(de)
    ld de,sp+2
    push af
    ld a,(de)
    ld h,a
    pop af
    sub h
    ld de,sp+2
    ld (de),a
    ld de,sp+9
    ld a,(de)
    ld de,sp+3
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+3
    ld (de),a
    ld de,sp+6
    ld a,(de)
    ld de,sp+0
    push af
    ld a,(de)
    ld h,a
    pop af
    sbc a,h
    ld de,sp+0
    ld (de),a
    ld de,sp+5
    ld a,(de)
    xor 080h
    ld (de),a
    ret


.mant_zero
    ld de,sp+0
    ld a,(de)
    ld h,a
    ld de,sp+2
    ld a,(de)
    or h
    ld h,a
    ld de,sp+3
    ld a,(de)
    or h
    ret


.mant_shr1
    ld de,sp+2
    ld a,(de)
    and 01h
    ld h,a
    ld de,sp+0
    ld a,(de)
    or a
    rra
    ld (de),a
    ld de,sp+3
    ld a,(de)
    rra
    ld (de),a
    ld de,sp+2
    ld a,(de)
    rra
    or h
    ld (de),a
    ret


.load_x_regs
    ld de,sp+5
    ld a,(de)
    ld b,a
    ld de,sp+4
    ld a,(de)
    ld c,a
    ld de,sp+0
    ld a,(de)
    ld l,a
    ld de,sp+3
    ld a,(de)
    ld d,a
    ld de,sp+2
    ld a,(de)
    ld e,a
    ld h,0
    ret


.load_ieee
    push de
    pop hl
    ld c,(hl)
    inc hl
    ld b,(hl)
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    ld h,b
    ld l,c
    ret



SECTION bss_fp_math32
swap_ret: defs 2
swap_x0: defs 2
swap_x1: defs 2
swap_x2: defs 2
swap_y0: defs 2
swap_y1: defs 2
swap_y2: defs 2
