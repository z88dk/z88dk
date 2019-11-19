;
;   Videoton TV Computer C stub
;   Sandor Vass - 2019
;   Based on the source of
;
;	Enterprise 64/128 C Library
;
;	Fputc_cons
;
;	Stefano Bodrato - 2011
;
;
;	$Id: fputc_cons.asm,v 1.5 2016-05-15 20:15:45 dom Exp $
;

	SECTION code_clib
	PUBLIC  fputc_cons_native


;
; Entry:        hl = points to char
;
.fputc_cons_native
	ld      hl,2
	add     hl,sp
	ld      a,(hl)
    ld      c,a
    rst     $30
    defb    $21 ; editor - character out
	ret

