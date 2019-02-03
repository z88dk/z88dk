

        MODULE  tms9918_console_vpeek
        SECTION code_clib
        PUBLIC  __tms9918_console_vpeek

        EXTERN  generic_console_font32
        EXTERN  generic_console_udg32
        EXTERN  screendollar
        EXTERN  screendollar_with_count
        EXTERN  msxbios
        EXTERN  __tms9918_screen_mode
        EXTERN  __tms9918_text_xypos

IF FORmsx
        INCLUDE "target/msx/def/msxbios.def"
ENDIF
IF FORsvi
        INCLUDE "target/svi/def/svibios.def"
ENDIF
IF FORmtx | FORpv2000 | FORsc3000 | FORm5 | FOReinstein | FORcoleco | FORspc1000
        EXTERN  LDIRMV
ENDIF

IF !FORspc1000 && !FOReinstein && !FORsvi
        PUBLIC  generic_console_vpeek
        defc    generic_console_vpeek = __tms9918_console_vpeek
ENDIF

__tms9918_console_vpeek:
        ld      a,(__tms9918_screen_mode)
        cp      2
        jr      z,vpeek_mode2
; So here we have the text modes
        push    ix
        call    __tms9918_text_xypos
        ; hl = screen address, now read that byte
        ex      de,hl
        push    de      ;Just some space
        ld      hl,0
        add     hl,sp
        ex      de,hl   ;de = space on stack, hl = screen address
        ld      bc,1
        ld      ix,LDIRMV
        call    msxbios
        pop     bc
        pop     ix
        ld      a,c
        and     a
        ret



vpeek_mode2:
        push    ix
        ld      a,c
        add     a
        add     a
        add     a
        ld      e,a        
        ld      d,b
        ld      hl,-8
        add     hl,sp
        ld      sp,hl
        push    hl                ;save buffer
        ; de = VDP address
        ; hl = buffer
        ex      de,hl
        ld      ix,LDIRMV
        ld      bc,8
        call    msxbios
        pop     de                ;buffer
        ld      hl,(generic_console_font32)
        call    screendollar
        jr      nc,gotit
        ld      hl,(generic_console_udg32)
        ld      b,128
        call    screendollar_with_count
        jr      c,gotit
        add     128
gotit:
        ex      af,af
        ld      hl,8
        add     hl,sp
        ld      sp,hl
        ex      af,af
        pop     ix
        ret
