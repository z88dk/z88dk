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
    PUBLIC  asm_fix16_sqrt


; Entry: h.l = Q8.8 number
; Exit:  h.l = sqrt of it
asm_fix16_sqrt:
    ld      a,h
    ld      c,l

;Adapted from Axe
sqrtfixed_88:
;Inputs: A.C
;Output: D.E contains the squareroot
;speed: 1482+12{0,17}
;min: 1482cc
;max: 1686cc
;avg: 1584cc
;35 bytes
	ld	b,12
	ld	de,0
	ld	h,d
	ld	l,e
__Sqrt88Loop:
	sub	$40
	sbc	hl,de
	jr	nc,__Sqrt88Skip
	add	a,$40
	adc	hl,de
__Sqrt88Skip:
	ccf
	rl	e
	rl	d
	sla	c
	rla
	adc	hl,hl
	sla	c
	rla
	adc 	hl,hl
	djnz	__Sqrt88Loop
    ex      de,hl           ;Get result into hl
	ret
