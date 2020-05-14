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
; f16_mul - z80 half floating point multiplication
;-------------------------------------------------------------------------
;

SECTION code_fp_math16

EXTERN _f16_inf
EXTERN _f16_nan

PUBLIC _f16_mul
PUBLIC _f16_calc_ax_bx_mantissa_and_sign

_f16_mul:
    call _f16_calc_ax_bx_mantissa_and_sign
    jr z,mul_handle_nan_inf
    add b   ; new_exp = ax + bx - 15
    sub 15
    exx 
    ld c,a ; save exp in bc'
    exx
    ld a,h
    or l
    ret z
    ex de,hl
    ld a,h
    or l
    ret z
    call mpl_11_bit  ; de/hl = m1*m2
    exx
    ld a,c
    exx 
    bit 5,e                      ; if v >=2048: m>>11, exp++
    jr nz,fmul_exp_inc_shift_11
    bit 4,e
    jr nz,fmul_shift_10         ; if v>=1024: m>>10
    jr fmul_handle_denormals    ; check denormals
fmul_exp_inc_shift_11:
    inc a
    sra e
    rr h
    rr l
fmul_shift_10:
    sra e
    rr h
    rr l
    sra e
    rr h
    rr l
    ld l,h ; ehl >> 8
    ld h,e
    ld e,0
    jr fmul_check_exponent
fmul_handle_denormals:
    sub a,10
    ld c,a
    ld b,0xf8
fmul_next_shift:    ; while ehl >= 2048
    ld a,h
    and b
    or e
    jr z,fmul_shift_loop_end
    sra e           ; ehl >> = 1, exp++
    rr h
    rr l
    inc c
    jr fmul_next_shift
fmul_shift_loop_end:
    ld a,c      ; restre exp
fmul_check_exponent:
    ld b,1
    and a
    jr z,fmul_denorm_shift
    bit 7,a
    jr z,final_combine
    neg 
    add a,b
    ld b,a
    xor a
fmul_denorm_shift:
    sra e
    rr h
    rr l
    djnz fmul_denorm_shift
final_combine:              
    cp 31
    jr nc, _f16_inf
    add a
    add a 
    res 2,h ; remove hidden bit
    or h
    ld h,a
    or 0x7F         ; reset -0 to normal 0
    or l
    ret z
    ex af,af' ; restore sign
    or h
    ld h,a
    ret
mul_handle_nan_inf:
    cp 31
    jr nz,mul_a_is_valid
    ld a,4
    xor h
    or l
    jp nz,_f16_nan ; exp=31 and mant!=0
mul_a_is_valid:
    ld a,b
    cp 31
    jr nz,mul_b_is_valid
    ld a,4
    xor d
    or e
    jp nz,_f16_nan ; exp=31 and mant!=0
mul_b_is_valid:
    ld a,h
    or l
    jp z,_f16_nan
    ld a,d
    or e
    jp z,_f16_nan
    jp _f16_inf 
    

    ; input hl,de
    ; output 
    ;   a=ax = max(exp(hl),1)
    ;   b=bx = max(exp(de),1)
    ;   hl = mantissa(hl)
    ;   de = mantissa(de)
    ;   z flag one of the numbers is inf/nan
    ;   no calcs done
    ;   a' sign = sign(hl)^sign(de)

_f16_calc_ax_bx_mantissa_and_sign:
    ld a,h
    xor d
    and 0x80
    ex af,af'
calc_ax_bx_mantissa:
    res 7,h
    res 7,d
    ld c,0x7c
    ld a,d
    and c
    jr z,bx_is_zero
    rrca  
    rra 
    ld b,a ; b=bx
    ld a,3
    and d      ; keep bits 0,1, set 2
    or 4      
    ld d,a     ; de = mantissa
    jr bx_not_zero 
bx_is_zero:
    ld b,1 ; de is already ok since exp=0, bit 7 reset
bx_not_zero:
    ; b is bx, de=mantissa(de)
    ld a,h
    and c
    jr z,ax_is_zero 
    rrca
    rra 
    ld c,a  ; c=exp
    ld a,3
    and h
    or 4
    ld h,a
    ld a,c ; exp=ax
exp_check_nan:
    ld c,a
    ld a,31
    cp c
    ret z
    cp b
    ld a,c ; restore exp(hl)
    ret
ax_is_zero:
    ld a,1 ; hl is already ok a=ax
    jr exp_check_nan


mpl_11_bit:
    ld b,d
    ld c,e
    ld d,h
    ld e,l
    xor a,a
    bit 2,b
	jr	nz,unroll_a
	ld	h,a  
	ld	l,a
unroll_a:
    add hl,hl
    rla
    bit 1,b
    jr  z,unroll_b
	add hl,de
    adc 0
unroll_b:
    add hl,hl
    rla
    bit 0,b
    jr z,unroll_c
    add hl,de
    adc 0
unroll_c:

    ld b,8

mpl_loop2:

	add	hl,hl  ; 
    rla
	rl c	   ; carry goes to de low bit
	jr	nc,mpl_end2
	add	hl,de
	adc 0
mpl_end2:

    djnz mpl_loop2
    ld e,a
    ld d,0
    ret

