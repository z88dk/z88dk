
	SECTION	code_fp_math48
	PUBLIC	_ftoe

        EXTERN  __convert_sdccf2reg
	EXTERN	l_glong
	EXTERN	_ftoe_impl


; sdcc implementation (l->r calling convention)
; (double x,int f,char *str);
._ftoe
        ld      hl,6    ; &x
        add     hl,sp
        call    l_glong
        ex      de,hl
        call    __convert_sdccf2reg
	push	ix	;save callers ix
        push    hl      ;get fp on stack in 6 byte format
        push    de
        ld      hl,0
        push    hl
        ld      hl,10   ;&f
        add     hl,sp
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        push    bc      ;f
        dec     hl
        dec     hl
        ld      b,(hl)  ;hl=&str
        dec     hl
        ld      c,(hl)
        push    bc      ;str
        call    _ftoe_impl
        pop     bc      ;restore stack
        pop     bc
        pop     bc
        pop     bc
        pop     bc
	pop	ix
        ret
