;
;	ZX Spectrum OPUS DISCOVERY specific routines
;
;	Stefano Bodrato - Jun. 2006
;
;	void opus_lptwrite (unsigned char databyte);
;
;	$Id: opus_lptwrite.asm $
;

    SECTION code_clib
    PUBLIC  opus_lptwrite
    PUBLIC  _opus_lptwrite

    EXTERN  opus_rommap

    EXTERN  P_DEVICE


opus_lptwrite:
_opus_lptwrite:
    push    ix
    ld      ix, 4
    add     ix, sp

    call    opus_rommap
		;call	$1708     ; Page in the Discovery ROM
    ld      h, (ix+0)      ; drive
    ld      b, 0           ; write
    ld      a, $81
    call    P_DEVICE
    call    $1748          ; Page out the Discovery ROM
    pop     ix
    ret

