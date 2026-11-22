;
; Z80 fixed Q8.8 maths routines
;
; These routines have been adapted from two sources:
;
; https://learn.cemetech.net/index.php/Z80:Advanced_Math
; 
; and
; 
; https://github.com/Zeda/Z80-Optimized-Routines/tree/master/math
;
;

    SECTION code_math
    PUBLIC  asm_fix16_sin
    PUBLIC  asm_fix16_cos

    EXTERN  l_mulu_32_16x16
    EXTERN  l_div

asm_fix16_cos:
    ld      de,0x0192           ;halfpi
    add     hl,de

;
;         int sign = fp & 0x8000;
;
;        fp %= 2 * FIX16_PI;
;        if ((fp > FIX16_HALFPI) && (fp <= FIX16_PI))
;                return sinfix16(FIX16_PI - fp) | sign;
;        else if ((fp > FIX16_PI) && (fp <= (FIX16_PI + FIX16_HALFPI))) {
;                return (sinfix16(fp - FIX16_PI)) | 0x8000;
;       } else if (fp > (FIX16_PI + FIX16_HALFPI)) {
;                return sinfix16((FIX16_PI << 1) - fp) | 0x8000;
;        }
;       return sign | sinfix16(fp);
;
;

; Entry: h.l = number
asm_fix16_sin:
; Clamping ranges
    ld      a,h
    and     128
    push    af              ;save the original sign
    ex      de,hl
    ld      hl,$0648        ;2 PI
    call    l_div           ;de = (param) % (2 PI)
;   if (fp > (FIX16_PI + FIX16_HALFPI)) {
;        return sinfix16((FIX16_PI << 1) - fp) | 0x8000;
;   }
    ld      hl,$0324 + $0192 + 1    ;FIX16_PI + FIX16_HALFPI
    and     a
    sbc     hl,de
    jr      nc,case_gt_pi

    ld      hl,+($0324 << 1)        ;FIX16_PI << 1
    and     a
    sbc     hl,de
    call    sine88
    pop     af          ;discard old sign
    set     7,h
    ret

case_gt_pi:
;   if (fp > FIX16_PI) {
;       return (sinfix16(fp - FIX16_PI)) | 0x8000;
;   }
    ld      hl,$0324 + 1   ;PI
    and     a
    sbc     hl,de
    jr      nc,case_gt_half_pi
    ex      de,hl
    ld      de,$0324     ;FIX16_PI
    and     a
    sbc     hl,de
    call    sine88
    pop     af          ;Discard original sign
    set     7,h
    ret

case_gt_half_pi:

; if ((fp > FIX16_HALFPI) 
;     return sinfix16(FIX16_PI - fp) | sign;
; }
    ld      hl,$0192 + 1     ;HALF_PI
    and     a
    sbc     hl,de
    jr      nc, case_lt_half_pi
    ld      hl,$0324            ;FIX16_PI
    and     a
    sbc     hl,de
    call    sine88
    pop     af
    or      h
    ld      h,a
    ret
case_lt_half_pi:
;   return sign | sinfix16(fp);
    ex      de,hl
    call    sine88
    pop     af
    or      h
    ld      h,a
    ret




; Entry: h.l = number
; Exit:  h.l = result
;
; This works for a limited range, so we clamp to that range on entry

 sine88:
     ex      de,hl
 ;Inputs: de
       push de
       sra d 
       rr e
       ld b,d 
       ld c,e
       call BC_Times_DE
       push hl     ;x^2/4
       sra h 
        rr l
       ex de,hl
       ld b,d 
        ld c,e
       call BC_Times_DE
       sra h 
        rr l
       inc h
       ex (sp),hl    ;x^4/128+1 is on stack, HL=x^2/4
       xor a
       ld d,a
       ld b,h
       ld c,l
       add hl,hl 
        rla
       add hl,hl 
        rla
       add hl,bc 
        adc a,d
       ld b,h
       ld c,l
       add hl,hl 
        rla
       add hl,hl 
        rla
       add hl,hl 
        rla
       add hl,hl 
        rla
       add hl,bc 
        adc a,d
       ld e,l
       ld l,h
       ld h,a
       rl e
       adc hl,hl
       rl e
       jr nc,$+3
       inc hl
   
       pop de
       ex de,hl
       or a
       sbc hl,de
       ex de,hl
       pop bc


; BC*DE->BHLA
BC_Times_DE:
    ld  hl,bc
    call    l_mulu_32_16x16     ;Gives dehl
                                ;bhla
    ld      a,l
    ld      l,h
    ld      h,e
    ld      b,d
    ret
