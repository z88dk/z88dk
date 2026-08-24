;
;       TRS 80 Model 100 C Library
;
;	Print character to the screen
;
;	Stefano Bodrato - Feb 2020
;	Alexei Gordeev - Nov 2020
;
;	$Id: fputc_cons.asm$
;
    SECTION code_clib
    PUBLIC  fputc_cons_native
    PUBLIC  _fputc_cons_native

    INCLUDE "target/m100/def/romcalls.def"

fputc_cons_native:
_fputc_cons_native:
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)

	push    af
    ROMCALL
    defw    $20   ; OUTC RST entry
	pop     af

    cp    13
	ret   nz

	ld    a,10
    ROMCALL
    defw    $20   ; OUTC RST entry
	ret
