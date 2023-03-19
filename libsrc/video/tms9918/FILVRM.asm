;
;        z88dk library: Generic VDP support code
;
;        FILVRM
;
;
;        $Id: gen_filvrm.asm,v 1.3 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
        PUBLIC  FILVRM
        EXTERN  SETWRT
        
        INCLUDE "video/tms9918/vdp.inc"
        
FILVRM:
        push    af
        push    bc
        call    SETWRT
        pop     hl
IF VDP_DATA > 0
        ld      bc, VDP_DATA
ENDIF
loop:         
        pop     af
IF VDP_DATA < 0
        ld      (-VDP_DATA),a
ELSE
        out     (c),a
ENDIF
        push    af
        dec     hl
        ld      a,h
        or      l
        jr      nz,loop
        pop     af
        ret
