;
;         ANSI Video handling for the MSX
;
;         Handles colors
;
;        Scrollup
;
;        Stefano Bodrato - Oct. 2017
;
;        $Id: f_ansi_scrollup.asm $
;

        SECTION code_video_vdp
        PUBLIC  ansi_SCROLLUP
        EXTERN  __tms9918_scroll_buffer
        EXTERN  __tms9918_attribute
        
IF FORmsx
        EXTERN  msxbios
        INCLUDE "target/msx/def/msxbios.def"
ELSE
IF FORsvi
        EXTERN  msxbios
        INCLUDE "target/svi/def/svibios.def"
ENDIF
ENDIF


.ansi_SCROLLUP
        push    ix
        ld      b,23
        ld      hl,256
.scloop
        push    bc
        push    hl
        ld      de,__tms9918_scroll_buffer
        ld      bc,256
        ld      ix,LDIRMV
        call    msxbios
        pop     hl
        push    hl
        ld      de,-256
        add     hl,de
        ld      de,__tms9918_scroll_buffer
        ld      bc,256
        ex      de,hl
        ld      ix,LDIRVM
        call    msxbios
        pop     hl
        push    hl
        ld      de,8192
        add     hl,de
        push    hl
        ld      de,__tms9918_scroll_buffer
        ld      bc,256
        ;ex de,hl
        ld      ix,LDIRMV
        call    msxbios
        pop     hl
        ld      de,-256
        add     hl,de
        ld      de,__tms9918_scroll_buffer
        ld      bc,256
        ex      de,hl
        ld      ix,LDIRVM
        call    msxbios
        pop     hl
        inc     h
        pop     bc
        djnz    scloop

        dec     h
        xor     a
        ld      bc,256
        ld      ix,FILVRM
        call    msxbios
        pop     ix
        ret
 

