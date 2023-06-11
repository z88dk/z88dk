;
; 	ANSI Video handling for the Alphatronic
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - 2022
;
;
;	$Id: f_ansi_attr.asm $
;

        SECTION  code_clib
        PUBLIC	ansi_attr

        EXTERN  __alphatro_attr


.ansi_attr
        and     a
        jr      nz,noreset
        ld      a,15
        jr      setbk
.noreset
        cp      1
        jr      nz,nobold
        ld      a,(__alphatro_attr)
        or      @01000000
        jr     	setbk
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        ld      a,(__alphatro_attr)
        and     @10111111
        jr      setbk
.nodim
        cp      4
        jr      nz,nounderline
        ld      a,(__alphatro_attr)
        or      @01001000
        ret
.nounderline
        cp      24
        jr      nz,noCunderline
        ld      a,(__alphatro_attr)
        and     @10110111
        ret
.noCunderline
        cp      5
        jr      nz,noblink
        ld      a,(__alphatro_attr)
        set     6,a
        jr      setbk
.noblink
        cp      25
        jr      nz,nocblink
        ld      a,(__alphatro_attr)
        res     6,a
        jr      setbk
.nocblink
        cp      7
        jr      nz,noreverse
        ld      a,(__alphatro_attr)
        set     7,a
        jr      setbk
.noreverse
        cp      27
        jr      nz,noCreverse
        ld      a,(__alphatro_attr)
        res     7,a
        jr      setbk
.noCreverse
        cp      8
        jr      nz,noinvis
        ld      a,(__alphatro_attr)
        ld      (oldattr),a
        and     7
        ld      e,a
        rla
        rla
        rla
        and     @00111000
        or      e
.setbk
        ld      (__alphatro_attr),a
        ret
.noinvis
        cp      28
        jr      nz,nocinvis
        ld      a,(oldattr)
        jr      setbk
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
        ld      a,(__alphatro_attr)
        and     @11111000
        or      e
        jr      setbk
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
        rlca
        rlca
        rlca
        and     @00111000
        ld      e,a
        ld      a,(__alphatro_attr)
        and     @11000111
        or      e
        jr      setbk
.noback
        ret




        SECTION  bss_clib
        
.oldattr
        defb     0

