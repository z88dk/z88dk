;       Entry: secondary=acc
;              onstack (under two return addresses) = primary
;
;
;       Exit:     z=number is zero
;              (nz)=number is non-zero 
;                 c=number is negative
;                nc=number is positive


                SECTION   code_l_sccz80
                PUBLIC    l_i64_cmp
		EXTERN	l_sub_64_mde_mhl
		EXTERN	__i64_acc


l_i64_cmp:
	ld	hl,4
	add	hl,sp
	ex	de,hl
	ld	hl,__i64_acc
	call	l_sub_64_mde_mhl	;de = de - hl
	


	;We've done the comparison and sp+4 is the result
	ld	hl,4 + 7
	add	hl,sp
	bit	7,(hl)
	jr	z,positive

	; Result is negative secondary < primary

	; nz is set
	; Cleanup stack
	pop	bc
	pop	de
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	push	de
	push	bc
        ld      hl,1    ; Saves some mem in comparision unfunctions
	scf
	ret
	


; Number is positive
positive:
	ld	b,7
	ld	a,(hl)
loop1:
	dec	hl
	or	(hl)
	djnz	loop1
	;Clean up stack
	pop	bc
	pop	de
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	push	de
	push	bc
	and	a	;Reflect equality + clear carry
        ld      hl,1    ; Saves some mem in comparision unfunctions
        ret


