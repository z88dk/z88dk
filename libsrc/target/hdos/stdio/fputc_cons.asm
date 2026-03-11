;
;	Heath/Zenith HDOS
;
;	(HL)=char to output to console
;
;	Stefano Bodrato - 2026
;
;
;	$Id: fputc_cons.asm $
;


    SECTION code_clib
    PUBLIC  fputc_cons_native

    INCLUDE "target/hdos/def/hdos.def"

fputc_cons_native:
    ld      hl, 2
    add     hl, sp
    ld      a, (hl)
    cp      12
    jr      nz, nocls
    ld      a, 27
    call    nocrlf
    ld      a, 'E'
nocls:
  IF    STANDARDESCAPECHARS
    cp      10
  ELSE
    cp      13
  ENDIF
    jr      nz, nocr
nocr:


  IF    STANDARDESCAPECHARS
    cp      10                          ; LF ?
    jr      nz, nocrlf
    ld      b, a
    call    nocrlf
    ld      a, 13
  ELSE
    cp      13                          ; CR ?
    jr      nz, nocrlf
    call    nocrlf
    ld      a, 10
  ENDIF
nocrlf:

    rst    38h
	defb   SCOUT
	ret
