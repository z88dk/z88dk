
    SECTION code_l_sccz80
    PUBLIC  l_i64_mod_u
    EXTERN  __i64_acc
    EXTERN  __i64_extra
    EXTERN  l_divu_64_64x64
    EXTERN  l_store_64_dehldehl_mbc

; Entry: acc = RHS (divisor)
;        sp+2 = LHS (dividend)
; Exit:  acc = LHS % RHS
l_i64_mod_u:
	ld	hl,2
	add	hl,sp
	ld	de,__i64_extra
	ld	bc,8
	ldir
	ld	ix,__i64_extra
	call	l_divu_64_64x64
	;dehl'dehl = remainder, copy it into fac
	ld	bc,__i64_acc
	call	l_store_64_dehldehl_mbc
	pop	de
        ld      hl,8
        add     hl,sp
        ld      sp,hl
        push    de
        ret
