;
;       SAM Coupé C Library
;
;       ANSI Video handling for SAM Coupé
;
;       Sets the attributes to default
;
;
;       Text Attributes
;       m - Set Graphic Rendition
;
;       The most difficult thing to port:
;       Be careful here...
;
;       Frode Tennebø - 29/12/2002
;
;       $Id: f_ansi_attr.asm,v 1.4 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
        PUBLIC    ansi_attr
        EXTERN     ansi_default
        EXTERN     ansi_restore

        EXTERN    UNDRLN

        PUBLIC    FOREGR
        PUBLIC    BACKGR

.ansi_attr
        and     a
        jr      nz,noreset
;         ld      a,7
;         ld      (23109),a
        jp      ansi_default
.noreset
        cp      1
        jr      nz,nobold
 ;       ld      a,(23109)
 ;       or      @01000000
 ;       ld      (23109),a
        ld      a,19            ; BRIGHT
        rst     16
        ld      a,1             ; ON
        rst     16
        ret
.nobold
        cp      2
;        jr      z,dim
;        cp      8
        jr      nz,nodim
;.dim
        ld      a,19            ; BRIGHT
        rst     16
        xor     a               ; OFF
        rst     16
;        ld      a,(23109)
;        and     @10111111
;        ld      (23109),a
        ret
.nodim
        cp      4
        jr      nz,nounderline
        ld      a,21            ; OVER
        rst     16
        ld      a,1             ; ON
        ld      (UNDRLN),a      ; underline on
        rst     16
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        ld      a,21            ; OVER
        rst     16
        xor     a               ; OFF
        ld      (UNDRLN),a      ; underline off
        rst     16
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,18            ; FLASH
        rst     16
        ld      a,1             ; ON
        rst     16
;        ld      a,(23109)
;        or      @10000000
;        ld      (23109),a
        ret
.noblink
        cp      25
        jr      nz,nocblink
        ld      a,18            ; FLASH
        rst     16
        xor     a               ; OFF
        rst     16
;        ld      a,(23109)
;        and     @01111111
;        ld      (23109),a
        ret
.nocblink
        cp      7
        jr      nz,noreverse
        ld      a,20            ; INVERSE
        rst     16
        ld      a,1             ; ON
        rst     16
;        ld      a,47
;        ld      (INVRS),a     ; inverse 1
        ret
.noreverse
        cp      27
        jr      nz,noCreverse
        ld      a,20            ; INVERSE
        rst     16
        xor     a               ; OFF
        rst     16
;        ld      (INVRS),a      ; inverse 0
        ret
.noCreverse
        cp      8
        jr      nz,noinvis
;        ld      a,(23109)
;        ld      (oldattr),a
;        and     @00111000
;        ld      e,a
;        rra
;        rra
;        rra
;        or      e
;        ld      (23109),a
        ld      a,16            ; INK
        rst     16
        ld      a,(BACKGR)      ; fetch colour
        rst     16
        ret
;.oldattr
;        defb     0
.noinvis
        cp      28
        jr      nz,nocinvis
;        ld      a,(oldattr)
;        ld      (23109),a
        ld      a,16            ; INK
        rst     16
        ld      a,(FOREGR)      ; fetch colour
        rst     16
        ret
.nocinvis
        cp      30
        jp      m,nofore
        cp      37+1
        jp      p,nofore

        sub     30
;'' Palette Handling ''
        rla
        bit     3,a
        jr      z,ZFR
        set     0,a
        and     7
.ZFR
;''''''''''''''''''''''
        ld      e,a
        ld      a,16            ; INK
        rst     16
        ld      a,e             ; colour
        ld      (FOREGR),a      ; store
        rst     16
;        ld      a,(23109)
;        and     @11111000
;        or      e
;        ld      (23109),a
        ret
.nofore
        cp      40
        jp      m,noback
        cp      47+1
        jp      p,noback

        sub     40
;'' Palette Handling ''
        rla
        bit     3,a
        jr      z,ZBK
        set     0,a
        and     7
.ZBK
;''''''''''''''''''''''
;        rla
;        rla
;        rla
        ld      e,a
        ld      a,17            ; PAPER
        rst     16
        ld      a,e             ; colour
        ld      (BACKGR),a      ; store
        rst     16

;        ld      a,(23109)
;        and     @11000111
;        or      e
;        ld      (23109),a
.noback
        ret

        SECTION bss_clib
.BACKGR
        defb 0
.FOREGR
        defb 0
