;
;       Small C+ Long Library Functions
;
;       Multiply 32 bit numbers
;
;       Entry: dehl=arg1
;       Staci: return address, arg2
;
;       Exit:  dehl=result

; djm note I don't particularly like the use of ix as a pointer to the
; second argument, however it makes it quite a short routine, alternate
; method might be to use bc and bc' to hold arg2 and use a as a loop
; counter - please feel free to experiment!


		XLIB	l_long_mult


;Use value on stack as the rotator...
;Alternate registers hold lower 16 bits
;Main registers hold upper 16 bits


.l_long_mult                       ; arg1 * arg2 -> res1, a=carry (bit 32)
        ld      ix,2
        add     ix,sp                   ;points to arg1
        ld      b,32                    ;bit counter
        push    hl              ;lower 16 bits
        exx                     
        pop     de
        ld      hl,0            ;lower 16 bits of res
        exx                    
        ld      hl,0            ;upper 16 bits of res
.l_long_mult1
        srl     (ix+3)          ;arg2 >> 1 -> arg2
        rr      (ix+2)
        rr      (ix+1)
        rr      (ix+0)
        jr      nc,l_long_mult2 ;don't add..
;Adding res1+arg2 -> res1
;switch to alternate to add lower 16 bits
        exx
        add     hl,de   ;lower 16 bits
        exx
        adc     hl,de   ;upper 16 bits

;rotate arg1 left by one bit
.l_long_mult2
        exx             ;lower 16 bits
        sla     e
        rl      d
        exx             ;upper 16 bits
        rl      e
        rl      d
        djnz    l_long_mult1
;Now, we have to get the number into the main set..
	push	hl	;upper 16
        exx
	pop	de
;Now..the stack!
        exx
        pop     bc      ;return address
        pop     de      ;the number (dump it..)
        pop     de
        push    bc
        exx             ;exit with result in dehl
        ret

