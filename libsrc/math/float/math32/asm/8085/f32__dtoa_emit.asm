;
;  feilipu, 2026 September
;
;  This Source Code Form is subject to the terms of the Mozilla Public
;  License, v. 2.0. If a copy of the MPL was not distributed with this
;  file, You can obtain one at http://mozilla.org/MPL/2.0/.
;
;-------------------------------------------------------------------------
; m32__dtoa_emit — write workspace to the classic ftoa/ftoe/ftog buffer
;-------------------------------------------------------------------------
;
; Workspace (BC):
;   +0 flags (bit 7 = negative)
;   +1 iz
;   +2 fz
;   +3 tz
;   +4 unused
;   +5 '0' carry
;   +6 digits (NUL-terminated)

SECTION code_clib
SECTION code_fp_math32

PUBLIC m32__dtoa_emit


.m32__dtoa_emit
    ; enter : hl = user dest
    ;         bc = workspace *
    ;         de = digit * (usually workspace+5 or +6)
    ;         carry set = special inf/nan (copy until NUL)
    ;
    ; uses  : af, bc, de, hl

    push af
    ld a,(bc)
    rla
    jp NC,no_sign
    ld (hl),'-'
    inc hl

.no_sign
    pop af
    jp C,special_copy

    ld a,(de)
    cp '0'
    jp NZ,copy_int
    inc de

.copy_int
    ld a,(de)
    cp '.'
    jp Z,do_iz
    cp 'E'
    jp Z,do_tze
    or a
    jp Z,finish
    ld (hl),a
    inc hl
    inc de
    jp copy_int

.do_iz
    inc bc                          ; &iz
    ld a,(bc)
    call put_zeroes
    ld (hl),'.'
    inc hl
    inc de                          ; skip '.'
    inc bc                          ; &fz
    ld a,(bc)
    call put_zeroes

.copy_frac
    ld a,(de)
    cp 'E'
    jp Z,do_tze_from_fz
    or a
    jp Z,do_tz_from_fz
    ld (hl),a
    inc hl
    inc de
    jp copy_frac

.do_tze
    inc bc
    inc bc
    inc bc                          ; &tz from flags
    jp tze_body

.do_tze_from_fz
    inc bc                          ; fz -> tz
    jp tze_body

.do_tz_from_fz
    inc bc                          ; fz -> tz
    jp tz_body

.tze_body
    ld a,(de)
    or 020h                         ; 'E' -> 'e'
    push af                         ; save exponent letter
    ld a,(bc)
    call put_zeroes
    pop af
    ld (hl),a
    inc hl
    inc de

.rest
    ld a,(de)
    or a
    jp Z,finish
    ld (hl),a
    inc hl
    inc de
    jp rest

.tz_body
    ld a,(bc)
    call put_zeroes

.finish
    xor a
    ld (hl),a
    ret

.special_copy
    ld a,(de)
    ld (hl),a
    or a
    ret Z
    inc hl
    inc de
    jp special_copy

.put_zeroes
    or a
    ret Z
.pz_loop
    ld (hl),'0'
    inc hl
    dec a
    jp NZ,pz_loop
    ret
