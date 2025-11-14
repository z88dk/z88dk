;       Entry: secondary=acc
;              onstack (under two return addresses) = primary
;
;
;       Exit:     z=number is zero
;              (nz)=number is non-zero 
;                 c=number is negative
;                nc=number is positive


                SECTION   code_l_sccz80
                PUBLIC    l_i64_ucmp
		EXTERN	l_sub_64_mde_mhl
		EXTERN	__i64_acc
		EXTERN  l_testzero_64_mhl


l_i64_ucmp:
	ld	hl,4
	add	hl,sp
	ex	de,hl
	ld	hl,__i64_acc
	call	l_sub_64_mde_mhl

	; If we have a carry then secondary > primary
	jr	c,secondary_bigger


	; We could have equality here
	ld	hl,4 
	add	hl,sp
	call	l_testzero_64_mhl

	; z/nz is set
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
	ccf
	ret
	


; Number is positive
secondary_bigger:
	;Clean up stack
	pop	bc
	pop	de
	ld	hl,8
	add	hl,sp
	ld	sp,hl
	push	de
	push	bc
        ld      hl,1    ; Saves some mem in comparision unfunctions
	ld	a,1
	and	a	;Sets nz
	scf
        ret


