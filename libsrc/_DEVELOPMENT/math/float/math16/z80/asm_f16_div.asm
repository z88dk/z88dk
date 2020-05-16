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
; f16_div - z80 half floating point division
;-------------------------------------------------------------------------
;

SECTION code_fp_math16

EXTERN asm_f16_inf
EXTERN asm_f16_nan

EXTERN asm_f16_calc_ax_bx_mantissa_and_sign

PUBLIC asm_f16_div

asm_f16_div:
    call asm_f16_calc_ax_bx_mantissa_and_sign
    jp z,div_handle_inf_or_nan
    sub b   ; new_exp = ax + bx - 15
    add 15
    ld b,a
    ld a,d
    or e
    jp z,div_handle_div_by_zero
    ld a,h
    or l
    ret z
    ld a,b
    push af
    ld b,d ;  save divider to bc
    ld c,e
    
    add hl,hl ; ehl = hl<10
    add hl,hl
    ld e,h  
    ld h,l
    ld l,0

    pop af ; a exp, ehl m1 bc m2
    call _div_24_by_15_ehl_by_bc
    ld b,a ; save new exp to b

    ld a,e
    or h
    or l
    ret z
div_loop_big:
    ld a,0xF8
    and h
    or e
    jr z,div_check_neg_or_zero_exp
    inc b
    sra e
    rr h
    rr l
    jr div_loop_big
div_check_neg_or_zero_exp:
    ld a,b
    dec a
    bit 7,a
    jr z,div_exp_positive
    ld a,1
    sub b
    ld b,0
    jr z,div_exp_positive
    ld b,a
div_denorm_shift:
    sra h
    rr l
    djnz div_denorm_shift
div_exp_positive:
    ld a,30
    cp b
    jp c,asm_f16_inf
    res 2,h
    ld a,b
    add a,a
    add a,a
    or h
    ld h,a
    ex af,af'
    or h
    ld h,a
    ret
div_handle_div_by_zero:
    ld a,h
    or l
    jp z,asm_f16_nan
    jp asm_f16_inf 
div_handle_inf_or_nan:
    ld c,a
    add b
    cp 62
    jp z,asm_f16_nan
    ld a,c
    cp 31
    jr nz,div_a_valid
    ld a,4
    xor h
    or l
    jp nz,asm_f16_nan
    ld a,d
    or e
    jp z,asm_f16_inf
div_a_valid:
    ld a,b
    cp 31
    jr nz,div_b_valid
    ld a,4
    xor d
    or e
    jp nz,asm_f16_nan
    ld hl,0 ; div by inf is 0
    ret
div_b_valid:
    ld a,h
    or l
    ret z
    jp asm_f16_inf


_div_24_by_15_ehl_by_bc:
    push ix
    ld ix,0
    add ix,sp
    push af ; set the exp at (ix-2)
    push hl
    ld a,e
    exx 
    ld c,a
    ex (sp),hl  ; chl = N ; save hl' on stack
    ld de,0
    ld b,d      ; bde = Q = 0
    exx
    ld hl,0
    ld e,c
    ld d,b
    ld b,24
div_int_next:
    
    exx 
    sla e ; Q <<= 1
    rl d
    rl b
    
    sla l  ; N<<=1
    rl h 
    rl c
    exx
    
    adc hl,hl ; R=R*2 + msb(N)
    sbc hl,de ; since hl <= 65536 don't need to clear carry
    jr nc,div_int_update_after_substr
    add hl,de ; fix sub
    djnz div_int_next
    jr div_int_done
div_int_update_after_substr:
    exx    ; Q++
    inc e  
    exx
    djnz div_int_next
div_int_done:
    exx
    ld a,0xFC       ; if ehl < 1024 && exp>0
    and d
    or b
    exx
    jr nz,div_final
    ld a,(ix-1)
    and a
    jr z,div_final
    inc b   ; set b to one sycle
    dec (ix-1)
    jr div_int_next
div_final:
    ex (sp),hl ; restore hl' (speccy thing) and put reminder to the stack
    exx
    ex de,hl
    ld e,b
    ld d,0
    pop bc ; get  reminder
    pop af ; restore exp 
    pop ix
    ret

