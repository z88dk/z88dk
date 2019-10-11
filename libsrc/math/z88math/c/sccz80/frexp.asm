
SECTION code_fp

PUBLIC frexp
EXTERN fa
EXTERN dload
EXTERN mbbc_ensure_float

IF FORz88
                INCLUDE  "target/z88/def/fpp.def"
ELSE
                INCLUDE "fpp.def"
ENDIF

; float frexpf (float x, int8_t *pw2);
frexp:
        ld      hl,4
        add     hl,sp
        call    dload
        pop     bc      ;Ret
        pop     de      ;pw2
        push    de
        push    bc
        ld      hl,fa+5
        ld      a,(hl)
        and     a
	call	z,convert_to_float
        ld      (hl),0
        jr      z,zero
        sub     $7f
        ld      (hl),$7f
zero:
        ld      (de),a
        rlca
        sbc     a
        inc     de
        ld      (de),a
        ret

convert_to_float:
	ld	c,0
	ld	hl,(fa+1)
	exx	
	ld	hl,(fa+3)
IF FORz88
        fpp(FP_FLT)
ELSE
        ld      a,FP_FLT
        call    FPP
ENDIF
	ld	a,c
	ld	(fa+5),a
	ld	(fa+3),hl
	exx
	ld	(fa+1),hl
	and	a
	ret

