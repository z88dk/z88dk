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
; f16_compare - z80 half floating point comparison
;-------------------------------------------------------------------------
;

SECTION code_fp_math16

PUBLIC _f16_compare

; input hl as A, de as B
; return bit 0,a = A > B;
; return bit 1,a = A == B
; return bit 2,a = A < B;

_f16_compare:
    ld bc,0x7C7F
    ld a,h
    and c
    cp b
    jr c,cmp_norm_hl_ok
    jr nz,cmp_norm_nan
    ld a,l
    and a
    jr nz,cmp_norm_nan
cmp_norm_hl_ok:
    ld a,d
    and c
    cp b
    jr c,cmp_norm_de_ok
    jr nz,cmp_norm_nan
    ld a,e
    and a
    jr nz,cmp_norm_nan
cmp_norm_de_ok:
    ld b,0x80
    ld a,h
    xor b
    ld h,a
    and b               
    jr nz,cmp_hl_fixed
    xor a   
    sub l
    ld l,a
    ld a,b
    sbc h
    ld h,a
cmp_hl_fixed:
    ld a,d
    xor b
    ld d,a
    and b
    jr nz,cmp_de_fixed
    xor a
    sub e
    ld e,a
    ld a,b
    sbc d
    ld d,a
cmp_de_fixed:
    and a ; make sure carry reset
    ret
cmp_norm_nan:
    pop hl
    ld hl,0
    ret

