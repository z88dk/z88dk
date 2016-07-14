;
; Z88 Runtime library
;
; Moved from z88_crt0.asm to library function
;

                SECTION   code_crt0_sccz80
PUBLIC l_div

EXTERN l_div_u
EXTERN L_DIVENTRY

IF !ARCHAIC

                
; The old routine was so cumbersome, so come up with a new one which
; will hopefully be a lot quicker and nicer!

; hl = hl/de   de= hl % de - signed!

;oops, it's the other way round!
; hl = de/hl   de=de % hl - hence the ex de,hl as first line!

.l_div

; Check for dividing by zero beforehand

        ld      a,h
        or      l
        ret     z
        ex      de,hl
        
;First have to obtain signs for quotient and remainder

        ld      a,h     ;dividend
        and     128
        ld      b,a     ;b = sgn(divisor)
        jr      z,l_div0
        
;if -ve make into positive number!

        sub     a
        sub     l
        ld      l,a
        sbc     a,a
        sub     h
        ld      h,a
        
.l_div0

        ld      a,d     ;divisor
        and     128
        ld      c,a     ;c = sgn(quotient)
        jr      z,l_div01
        
        sub     a
        sub     e
        ld      e,a
        sbc     a,a
        sub     d
        ld      d,a

.l_div01

        or a
        push bc         ;save signs
        call    l_div_u + L_DIVENTRY  ; unsigned divide but skip zero check

;Now do the signs..

        pop     bc      ;c = sgn(quotient), b = sgn(divisor)
        ex      de,hl
        
;de holds quotient, hl holds remainder

        ld      a,c
        xor b
        call m, dosign  ;quotient
        ld      a,b
        ex      de,hl   ;remainder (into de)
        
;Do the signs - de holds number to sign, a holds sign

        and     128
        ret     z       ;not negative so okay..

.dosign

        sub     a
        sub     e
        ld      e,a
        sbc     a,a
        sub     d
        ld      d,a
        ret

ENDIF




IF ARCHAIC


;These are now in libraries!
                EXTERN     l_deneg
                EXTERN     l_bcneg


; HL = DE / HL, DE = DE % HL

.l_div 
        ld b,h
        ld c,l
        ld a,d
        xor   b
        push  af
        call    m,l_deneg
;      call CALL_
;   .dw cm_de
        call  m,l_bcneg       ; ZShell mod
;   call CALL_
;   .dw cm_bc
        ld a,16
        push  af
        ex de,hl
        ld de,0
.l_div1   
        add   hl,hl
; {DE <r<r 1}
.l_rdel   
        ld a,e
        rla
        ld e,a
        ld a,d
        rla
        ld d,a
        or e
        jr z,l_div2
; {BC : DE}
.l_cmpbd 
        ld  a,e
        sub   c
        ld a,d
        sbc   a,b
        jp m,l_div2               ; ZShell mod
        ld a,l
        or 1
        ld l,a
        ld a,e
        sub   c
        ld e,a
        ld a,d
        sbc   a,b
        ld d,a
.l_div2   
        pop   af
        dec   a
        jr z,l_div3
        push  af
        jr l_div1
.l_div3   
        pop   af
        ret   p
        call  l_deneg
        ex de,hl
        call  l_deneg
        ex de,hl
        ret

ENDIF
