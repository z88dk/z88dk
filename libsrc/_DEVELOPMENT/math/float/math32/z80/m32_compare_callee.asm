	SECTION	code_fp_math32
	PUBLIC	m32_compare_callee

; Compare two IEEE floats. NB. Needs to handle -0 == +0
;       Entry: dehl=secondary
;              onstack (sp+4: under two return addresses) = primary
;
;       Exit:     z=number is zero
;              (nz)=number is non-zero
;                 c=number is left > right
;                nc=number is right < left

m32_compare_callee:
        pop     bc      ;return address from this function
                        ;this leaves return address to real program
                        ;and the primary on the stack

        exx             ;left
        pop     bc
        pop     hl
        pop     de
        push    bc      ;return address to program
        ld      a,l
        exx		;right
        push    bc      ;return address from function
        sub     l
        ld      c,a	
        exx             ;left
        ld      a,h
        exx             ;right
        sbc     a,h
        ld      b,a
	ld	a,e
        exx             ;left
        sbc     a,e
	ld	c,a
        exx             ;right
        ld      a,d
        exx             ;left
        sbc     a,d
        ld      b,a

	; left dehl = float, bc = highword of result
	; right dehl = float, bc = low word of result

	; Calculate zero state of result
	ld	a,b
	or	c
	exx
	or	b
	or	c
	exx

	; If sign is set then left > right
	ld	hl,1
	rlc	b
	ret
	
