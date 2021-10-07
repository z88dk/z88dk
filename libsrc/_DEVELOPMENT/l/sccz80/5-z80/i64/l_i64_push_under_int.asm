    SECTION code_l_sccz80
    PUBLIC  l_i64_push_under_int
    PUBLIC  l_i64_push_under_int_mhl
    EXTERN  __i64_acc


; Stack: defw ret address
;        defw funcptr
;        def  other args
;
; Exit stack:
;        defw retaddress
;        defll int64_t
; Exit:    hl == function pointer
l_i64_push_under_int:
        ld      hl,__i64_acc
l_i64_push_under_int_mhl:
	ex	de,hl
	exx
        pop     de	;Return address
	pop	bc	;Function pointer
	exx
        ld      hl,-8
        add     hl,sp
        ld      sp,hl
	exx
        push    de
	push	bc	;Function pointer
	exx
        ex      de,hl
        ld      bc,8
        ldir
	pop	hl
        ret
