;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; ftoa — classic %f text via the stack-only dtoa engine
;-------------------------------------------------------------------------
;
; void ftoa(double x, int prec, char *str)  (sccz80 smallc)
; enter: sp+2 = str, sp+4 = prec, sp+6 = x (LSW then MSW)
;
; Workspace at SP after open:
;   +0 flags  +1 iz  +2 fz  +3 tz  +4 prec  +5 '0'
;   +6 digits ...
;   +24 B temp  +25 C temp  +30 dst pointer
;   +32 prec/flags  +34 x(4)  +38 dest  +40 ret

SECTION code_clib
SECTION code_fp_math32

PUBLIC ftoa
PUBLIC _ftoa
PUBLIC m32__dtoa_f_core
PUBLIC m32__dtoa_f_join
PUBLIC m32__dtoa_prune
PUBLIC m32__dtoa_g_strip
PUBLIC m32__dtoa_finish
PUBLIC m32__dtoa_putc
PUBLIC m32__dtoa_getdst

EXTERN m32_fpclassify
EXTERN m32__dtoa_sgnabs
EXTERN m32__dtoa_base10
EXTERN m32__dtoa_digits
EXTERN m32__dtoa_round
EXTERN m32__dtoa_special
EXTERN m32__dtoa_emit


.ftoa
._ftoa
    ld hl,sp+2
    ld c,(hl+)
    ld b,(hl)
    push bc
    ld hl,sp+6
    ld a,(hl)
    ld hl,sp+8
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)
    ld hl,bc
    ld b,0
    call m32__dtoa_f_core
    ret


.m32__dtoa_f_core
    ; dehl = x, a = prec, b = flags, stack = dest, ret
    push de
    push hl
    ld c,b
    ld b,a
    push bc
    ld hl,sp-32
    ld sp,hl

    ld hl,sp+32
    ld c,(hl+)                      ; flags (push bc stored C first)
    ld b,(hl)                       ; prec
    xor a
    ld hl,sp+0
    ld (hl+),c
    ld (hl+),a
    ld (hl+),a
    ld (hl+),a
    ld (hl+),b
    ld (hl),'0'

    ld hl,sp+6
    ld b,18
.zdig
    ld (hl+),a
    dec b
    jp NZ,zdig

    ld hl,sp+6
    ld bc,hl
    ld hl,sp+30
    ld (hl+),c
    ld (hl),b

    ld hl,sp+34
    ld c,(hl+)
    ld b,(hl+)
    ld e,(hl+)
    ld d,(hl)
    ld hl,bc

    call m32__dtoa_sgnabs
    or a
    jp Z,abs_ok
    push de
    push hl
    ld hl,sp+4
    ld a,(hl)
    or 080h
    ld (hl),a
    pop hl
    pop de

.abs_ok
    call m32_fpclassify
    or a
    jp Z,normal_form

    ld hl,sp+6
    call m32__dtoa_special
    jp C,spec_done
    ld hl,sp+4
    ld a,(hl)
    ld hl,sp+3
    ld (hl),a
    jp m32__dtoa_prune

.spec_done
    ld bc,hl
    ld hl,sp+30
    ld (hl+),c
    ld (hl),b
    scf
    jp m32__dtoa_finish

.normal_form
    call m32__dtoa_base10

.m32__dtoa_f_join
    ; dehl = mantissa, b = e, c = sig
    ld a,b
    or a
    jp M,fraction_only

    inc a
    ld b,a
    call m32__dtoa_digits
    jp C,fraction_begin

    ld a,'0'
    call m32__dtoa_putc
    dec b
    ld a,b
    ld hl,sp+1
    ld (hl),a

.fraction_begin
    ld a,'.'
    call m32__dtoa_putc

.fraction_digits
    push de
    push hl
    ld hl,sp+8
    ld b,(hl)
    inc b
    pop hl
    pop de
    call m32__dtoa_digits
    jp C,do_round

    dec b
    ld a,b
    ld hl,sp+3
    ld (hl),a
    jp m32__dtoa_prune

.do_round
    call m32__dtoa_getdst
    call m32__dtoa_round            ; HL at extra rounding digit
    ld bc,hl
    ld hl,sp+30
    ld (hl+),c
    ld (hl),b                       ; exclude extra digit
    jp m32__dtoa_prune

.fraction_only
    ld a,'0'
    call m32__dtoa_putc
    ld a,'.'
    call m32__dtoa_putc
    ld a,b
    neg
    dec a
    jp Z,fraction_digits
    dec a
    push de
    push hl
    ld hl,sp+8
    ld b,(hl)
    pop hl
    pop de
    cp b
    jp NC,prec_less
    push de
    push hl
    ld hl,sp+28
    ld (hl),a                       ; park |e|-2 at work+24
    pop hl
    pop de
    ld a,'0'
    call m32__dtoa_putc
    push de
    push hl
    ld hl,sp+28
    ld a,(hl)
    ld hl,sp+6
    ld (hl),a                       ; fz
    pop hl
    pop de
    sub b
    cpl
    push de
    push hl
    ld hl,sp+8
    ld (hl),a                       ; remaining prec
    pop hl
    pop de
    jp fraction_digits

.prec_less
    ld a,b
    ld hl,sp+3
    ld (hl),a
    jp m32__dtoa_prune


.m32__dtoa_prune
    ld hl,sp+0
    ld a,(hl)
    and 002h
    jp Z,m32__dtoa_finish
    ld a,(hl)
    and 010h
    jp NZ,m32__dtoa_finish

    xor a
    ld hl,sp+3
    ld (hl),a                       ; tz = 0

    call m32__dtoa_g_strip
    xor a                           ; NC: not special
    jp m32__dtoa_finish


; Strip trailing '0' for %g.  Cursor sits at the extra rounding
; digit (or one past the last kept digit).  Walk back; if the
; remainder is "n." drop the decimal point too.
.m32__dtoa_g_strip
    ; CALL: work at SP+2, cursor at SP+32
    ld hl,sp+32
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    dec hl
    ld a,'0'

.zloop
    cp (hl)
    jp NZ,zdone
    dec hl
    jp zloop

.zdone
    ld a,'.'
    cp (hl)
    jp NZ,z_keep
    push hl
    xor a
    ld hl,sp+6
    ld (hl),a                       ; fz = work+2
    pop hl
    jp zstore                       ; NUL at '.'

.z_keep
    inc hl                          ; keep last non-zero
.zstore
    ld bc,hl
    ld hl,sp+32
    ld (hl+),c
    ld (hl),b
    ret

.m32__dtoa_finish
    ld a,0
    jp NC,fin_ns
    inc a                           ; A=1 if special
.fin_ns
    ld hl,sp+25
    ld (hl),a                       ; park special flag
    call m32__dtoa_getdst
    xor a
    ld (hl),a                       ; NUL

    ld hl,sp+0
    ld de,hl                        ; DE = work
    ld hl,sp+25
    ld a,(hl)
    or a
    ld a,5
    jp Z,fin_off
    ld a,6
.fin_off
    add a,e
    ld e,a
    ld a,d
    adc a,0
    ld d,a                          ; DE = &carry or &digits
    ld hl,sp+0
    ld bc,hl                        ; BC = work
    ld hl,sp+40
    ld a,(hl+)
    ld h,(hl)
    ld l,a                          ; HL = dest (under ret-to-wrapper)
    call m32__dtoa_emit

    ld hl,sp+42
    ld sp,hl                        ; drop work + pf + x + ret-wrapper + dest
    ret                             ; to ftoa's caller


.m32__dtoa_putc
    ; CALL + 4 pushes: work at SP+10, cursor at SP+40
    ; Keep AF/BC/DE/HL: DEHL is the live mantissa, BC holds counters.
    push af
    push bc
    push de
    push hl
    ld e,a
    ld hl,sp+40
    ld a,(hl+)
    ld d,(hl)
    ld l,a
    ld h,d
    ld (hl),e
    inc hl
    ld bc,hl
    ld hl,sp+40
    ld (hl+),c
    ld (hl),b
    pop hl
    pop de
    pop bc
    pop af
    ret


.m32__dtoa_getdst
    ; CALL pushed ret: cursor at SP+32
    ld hl,sp+32
    ld a,(hl+)
    ld h,(hl)
    ld l,a
    ret
