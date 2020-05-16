; Copyright (c) 2020 Artyom Beilis

; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:

; The above copyright notice and this permission notice shall be included in
; all copies or substantial portions of the Software.

; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
; THE SOFTWARE.
;
;
; feilipu, 2020 May
;
;-------------------------------------------------------------------------
; f16_add - z80 half floating point addition
;-------------------------------------------------------------------------
;

SECTION code_fp_math16

EXTERN asm_f16_inf
EXTERN asm_f16_nan
EXTERN asm_f16_sub

PUBLIC asm_f16_add

asm_f16_add:
    ld a,h
    xor d
    and 0x80
    jr z,fast_add_do_add
    xor d
    ld d,a
    jp asm_f16_sub
fast_add_do_add:
    ld a,0x80
    and h
    ex af,af' ; save sign in AF'
    res 7,d
    res 7,h
    ld a,l
    sub e
    ld a,h
    sbc d
    jr nc,fast_add_noswap
    ex de,hl
fast_add_noswap:
    ld c,0x7C
    ld a,c
    and d
    cp c
    jp z,add_handle_nan_or_inf
    ld b,a ; bx in b
    ld a,h
    and c
    cp c
    jp z,add_handle_nan_or_inf
    sub b
    jr z,fast_add_diff_0
    rra  ; carry is reset due to 
    rra  ; low bits are zero so no problem
    ld c,a ; c=shift
    ld a,b ; 
    or a 
    jr z, fast_add_bx_is_zero
    ld a,d
    and 3
    or 4
    ld d,a
    ld b,c
fast_add_shift_a:
    sra d
    rr e
    djnz fast_add_shift_a
    jr fast_add_actual_add
fast_add_bx_is_zero:
    dec c
    jr z,fast_add_actual_add
    ld b,c
fast_add_shift_b:
    sra d
    rr e
    djnz fast_add_shift_b
    jr fast_add_actual_add
fast_add_diff_0:
    ld a,b
    or a
    jr nz,fast_add_bx_not_zero_diff_zero
    add hl,de
    ex af,af'
    or a,h
    ld h,a
    ret
fast_add_bx_not_zero_diff_zero:
    ld a,d
    and 3
    or 4
    ld d,a
fast_add_actual_add: 
    ld b,h  ; save hl
    ld c,l
    add hl,de  ; compare (hl+de) & 0x7c00 == 0x7c00 & hl stored in bc
    ld a,b
    xor h
    and 0x7C
    jr nz,fast_add_update_exp 
    ex af,af'
    or a,h
    ld h,a
    ret
fast_add_update_exp:
    ld a,b
    and 3
    or 4
    ld h,a
    ld l,c
    add hl,de
    sra h
    rr l
    res 2,h
    ld a,b
    and 0x7C
    add 4
    ld b,a
    and 0x7C
    cp 0x7C
    jp z,asm_f16_inf
    ex af,af'
    or b
    or h
    ld h,a
    ret
add_handle_nan_or_inf:
    ld c,0x7c
    ld a,h
    cp c
    jr c,add_a_not_inv
    xor c
    or l
    jp nz,asm_f16_nan
add_a_not_inv:
    ld a,d
    cp c
    jr c,add_b_not_inv
    xor c
    or e
    jp nz,asm_f16_nan
add_b_not_inv:
    jp asm_f16_inf

