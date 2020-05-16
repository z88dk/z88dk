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
; f16_sub - z80 half floating point subtraction
;-------------------------------------------------------------------------
;

SECTION code_fp_math16

EXTERN asm_f16_inf
EXTERN asm_f16_nan
EXTERN asm_f16_add

PUBLIC asm_f16_sub

asm_f16_sub:
    ld a,h
    xor d
    and 0x80
    jr z,fast_sub_do_sub
    xor d
    ld d,a
    jp asm_f16_add
fast_sub_do_sub:
    ld a,0x80
    and h
    ex af,af' ; save sign in AF'
    res 7,d
    and a
    rl e
    rl d
    res 7,h
    and a
    rl l
    rl h  ; shift both by 1 bit
    ld a,l
    sub e
    ld a,h
    sbc d
    jr nc,fast_sub_noswap
    ex de,hl
    ex af,af'
    xor 0x80
    ex af,af'
fast_sub_noswap:
    ld c,0xF8
    ld a,c
    and d
    cp c
    jp z,sub_handle_nan_or_inf
    ld b,a ; bx in b
    ld a,h
    and c
    cp c
    jr z,sub_handle_nan_or_inf
    sub b
    jr z,fast_sub_diff_0

    rra  ; carry is reset due to 
    rra  ; low bits are zero so no problem
    rra 

    ld c,a ; c=shift
    ld a,b ; 
    or a 
    jr z, fast_sub_bx_is_zero
    ld a,d
    and 7
    or 8
    ld d,a
    ld b,c
fast_sub_shift_a:
    sra d
    rr e
    djnz fast_sub_shift_a
    jr fast_sub_actual_sub
fast_sub_bx_is_zero:
    dec c
    jr z,fast_sub_actual_sub
    ld b,c
fast_sub_shift_b:
    sra d
    rr e
    djnz fast_sub_shift_b
    jr fast_sub_actual_sub
fast_sub_diff_0:        
    ld a,b
    or a
    jr nz,fast_sub_bx_not_zero_diff_zero
    sbc hl,de
    jr fast_sub_shift_add_sign_and_ret
fast_sub_bx_not_zero_diff_zero:
    ld a,d
    and 7
    or 8
    ld d,a
fast_sub_actual_sub: 
    ld b,h  ; save hl
    ld c,l
    and a ; reset carry
    sbc hl,de
    ; compare (hl-de) & 0xf800 == 0xf800 & hl stored in bc
    ld a,b
    xor h
    and 0xf8
    jr z,fast_sub_shift_add_sign_and_ret
    
    ld a,b
    and 7
    or 8
    ld h,a
    ld l,c
    sbc hl,de
    jr z,fast_sub_shift_add_sign_and_ret
    ld a,0xF8
    and b
    jr z,fast_sub_break_shift_loop
fast_sub_shift_loop:
    bit 3,h
    jr nz,fast_sub_break_shift_loop
    sub a,8
    jr z,fast_sub_break_shift_loop
    add hl,hl
    jr fast_sub_shift_loop
fast_sub_break_shift_loop:
    res 3,h
    or h
    ld h,a
fast_sub_shift_add_sign_and_ret:
    and a ; reset C
    rr h
    rr l 
    ld a,h ; check for 0 - make sure not to return -0
    or l
    ret z
    ex af,af'
    or a,h
    ld h,a
    ret
sub_handle_nan_or_inf:
    ld c,0xF8
    ld a,h
    cp c
    jr c,sub_a_not_inv
    xor c
    or l
    jr nz,asm_f16_nan
sub_a_not_inv:
    ld a,d
    cp c
    jr c,asm_f16_inf
    xor c
    or e
    jr nz,asm_f16_nan ;
    sbc hl,de ; check if both are inf
    jr z,asm_f16_nan 
    and a
    add hl,de
    ld a,h
    xor c
    or l
    jr z,asm_f16_inf
    ex af,af'
    xor 0x80
    ex af,af'
    jp asm_f16_inf

