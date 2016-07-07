
	MODULE _vsnprintf
	SECTION	code_clib

	PUBLIC	_vsnprintf

	EXTERN	asm_printf
	EXTERN	sprintf_outc




;void vsnprintf(char *buf, size_t, char *fmt,va_list ap)
; int vfprintf1(FILE *fp, void __CALLEE__ (*output_fn)(int c,FILE *fp), int sccz80, unsigned char *fmt,void *ap)

_vsnprintf:
	ld	hl,2	
	add	hl,sp		;&buf

	push	ix
        ld      c,(hl)  ;buf
        inc     hl
        ld      b,(hl)
        inc     hl
        ld      e,(hl)  ;len
        inc     hl
        ld      d,(hl)
        inc     hl
        push    de
        push    bc
        ex      de,hl
        ld      hl,0
        add     hl,sp
        push    hl              ;save fp
        ld      bc,sprintf_outc
        push    bc
        ld      bc,0            ;sdcc
        push    bc
        ex      de,hl
        ld      c,(hl)
        inc     hl
        ld      b,(hl)
        inc     hl
        push    bc              ;fmt
	ld	c,(hl)
	inc	hl
	ld	b,(hl)
        push    bc              ;ap
        call    asm_printf
	ex	de,hl
	ld	hl,10+4
	add	hl,sp
	ld	sp,hl
	ex	de,hl
	pop	ix
	ret


