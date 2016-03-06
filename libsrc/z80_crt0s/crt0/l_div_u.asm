;
; Z88 Runtime library
;
; Moved from z88_crt0.asm to library function
;
; This is the unsigned routine...disregards signs and just does it..

                SECTION   code_crt0_sccz80
PUBLIC     l_div_u
PUBLIC     L_DIVENTRY
                
; The old routine was so cumbersome, so come up with a new one which
; will hopefully be a lot quicker and nicer!

; hl = hl/de   de= hl % de     - unsigned..

; Actually it's: hl=de/hl de=de%hl

.l_div_u

;First have to obtain signs for quotient and remainder
;Check for dividing by zero, if so, return hl=0 and de=dividend

        ld      a,h
        or      l
        ret     z
        ex      de,hl

;Now, we have two positive numbers so can do division no problems..

.entry

        ld      b,16    ;counter
        ld      a,h     ;arg1
        ld      c,l
        ld      hl,0    ;res1
        
; hl=res1 de=arg2 ac=arg1
;        and     a

.l_div1

        rl      c       ;arg1 << 1 -> arg1
        rla
        adc     hl,hl   ;res1 << 1 -> res1
        sbc     hl,de   ;res1 - arg2 -> res1
        jr      nc,l_div2
        add     hl,de   ;res1 + arg2 -> res1
        
.l_div2

        ccf
        djnz    l_div1
        
        rl      c       ;arg1 << 1 -> arg1
        rla
        
;Have to return arg1 in hl and res1 in de

        ld      d,a
        ld      e,c
        ex      de,hl
        ret

DEFC L_DIVENTRY = # entry - l_div_u
