
#ifndef FILES
#asm
.i_52
	ld	hl,40	;const
	add	hl,sp
	ld	sp,hl		; STICKER
	ld	hl,65535	;const
	ret
#endasm
#endif

#ifndef SHORT

#asm
; Repeated pattern are replaced by the following subroutines

.clisp_opt3b
	ld	(clisp_opt3_smc+1),a
	jr	clisp_opt3_common
.clisp_opt3a
	ld	hl,(_errmsg_ill_type)
.clisp_opt3
	ld	a,16
	ld	(clisp_opt3_smc+1),a
	push	hl
	ld	hl,1	;const
	push	hl
	ld	hl,24	;const
	call	l_glongsp	;
	call	_err_msg	; __opt3__
.clisp_opt3_common
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	call	l_int2long_s
	exx
.clisp_opt3_smc
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret

.clisp_opt4a
	pop af
	ex af,af
	ld	hl,8	;const
	add	hl,sp
	xor	a
	ld	(hl),a
	inc	hl
	ld	(hl),a
	inc	hl
	ld	(hl),a
	inc	hl
	ld	(hl),a
	ld	hl,12	;const
	add	hl,sp
	push	hl
	ld	hl,20	;const
	jr	_clisp_opt4a
.clisp_opt4
	pop af
	ex af,af
._clisp_opt4a
	add	hl,sp
	call	l_glong	; __opt4__
	pop	bc
	call	l_plong
	ex af,af
	push af
	ret

.clisp_opt11
	ld	hl,4	;const
	add	hl,sp
	jp	l_glong


.clisp_opt13a
	ld	hl,14	;const
	call	l_gintspsp	;
	jr		clisp_opt13
.clisp_opt13b
	inc hl
	inc hl
	add	hl,sp
	push	hl
.clisp_opt13
	ld	hl,0	;const
	ld	d,h
	ld	e,l
	pop	bc
	pop af
	ex	af,af
	call	l_plong
	ex	af,af
	push af
	ret

.clisp_opt14
	ld	hl,65535	;const
	call	l_int2long_s
	exx			; __opt14__
	ld	hl,16	;const
	add	hl,sp
	ld	sp,hl
	exx
	ret

.clisp_opt15
	inc	a
	inc	a
	ld	l,a
	ld	h,0
	call	l_gintsp	;
	call	_l_car
	jp	_l_eval

#endasm
#endif

#asm

;  Common optimizations (valid for both SHORT and default options)

.pop_ret1
	pop	bc
.pop_ret2
	pop	bc
.pop_ret3
	pop	bc
	pop	bc
	pop	bc		; STICKER
	pop	bc
	ret

.clisp_opt27
	ld	h,0
	ld	l,a
	add	hl,sp
	ld	de,0	;const
	ex	de,hl
	jp	l_pint

.l_case_squeezed
        ex de,hl                ;de = switch value
        pop hl                  ;hl -> switch table
.swloop
        ld c,(hl)
        inc hl
        ld b,(hl)               ;bc -> case addr, else 0
        inc hl
        ld a,b
        or c
IF CPU_INTEL
        jp z,swend              ;default or continuation code
ELSE
        jr z,swend              ;default or continuation code
ENDIF
        ld a,(hl)
        inc hl
        cp e
        ;ld a,(hl)
;        inc hl
IF CPU_INTEL
        jp nz,swloop
ELSE
        jr nz,swloop
ENDIF
;        cp d
;IF CPU_INTEL
;        jp nz,swloop
;ELSE
;        jr nz,swloop
;ENDIF
        ld h,b                  ;cases matched
        ld l,c
.swend
        jp (hl)



#endasm


#ifdef SHORT

#asm

._D_TEST_TAG
	push	hl
	ld	a,h
	and	+(112 % 256)
	ld	h,a
	ld	l,0
	and	a
	sbc	hl,de
	pop	bc
	ret


.clisp_opt20
	ld	h,0
	ld	l,a
	call	l_gintsp	;
	jp	l_gint	;

.clisp_opt21
	ld	h,0
	ld	l,a
	call	l_gintsp	;
	jp	_l_car	;

.clisp_opt22
	ld	h,0
	ld	l,a
	call	l_gintsp	;
	jp	_D_GET_TAG

.clisp_opt23
	push	hl
	ld	hl,1	;const
	push	hl
	ld	hl,18	;const
	call	l_gintsp	;
	push	hl
	call	_err_msg
	pop	bc
	pop	bc
	pop	bc
	jr	clisp_opt24_sub

.clisp_opt24
	ld	hl,65535	;const
.clisp_opt24_sub
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	pop	bc
	ret

.clisp_opt25
	ld	h,0
	ld	l,a
	call	l_gintsp	;__opt25__
	call	_l_car	;
	jp	_l_eval

.clisp_opt26
	ld	h,0
	ld	l,a
	call	l_gintsp	;__opt26__
	call	_l_cdr
	call	_l_car
	jp	_l_eval


.clisp_opt28
	ld	h,0
	ld	l,a
	call	l_gintspsp	;
	ld	hl,0	;const
	push	hl
	call	_l_cons
	pop	bc
	pop	bc
	ret

#endif

#endasm


