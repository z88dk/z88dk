
	MODULE _vfscanf
	SECTION	code_clib

	PUBLIC	_vfscanf

        EXTERN  asm_scanf




; sdcc version
;void vfscanf(FILE *fp, char *fmt,va_list ap)
_vfscanf:
    ld      hl,7
    add     hl,sp
    ld      b,(hl)      ;fp
    dec     hl
    ld      c,(hl)
    dec     hl
    ld      d,(hl)      ;fmt
    dec     hl
    ld      e,(hl)
    dec     hl
    ld      a,(hl)      ;fp
    dec     hl
    ld      l,(hl)
    ld      h,a
IF !__CPU_INTEL__
	push	ix	;save callers
ENDIF
	push	hl	;fp
	ld	hl,0	;sdcc mode
	push	hl
	push	de	;fmt
	push	bc	;ap
	call	asm_scanf
	pop	bc
	pop	bc
	pop	bc
	pop	bc
IF !__CPU_INTEL__
	pop	ix	;restore callers
ENDIF
	ret


