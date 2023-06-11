;
; 	ANSI Video handling for the Visual 1050
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - 2023
;
;
;	$Id: f_ansi_attr.asm $
;

        SECTION  code_clib

        PUBLIC	ansi_attr
        EXTERN    v1050_sendchar

.ansi_attr
        and     a
        jr      nz,noreset
		jp      clear_attrs
.noreset
        ld      hl,BOLD
        cp      1
        jr      nz,nobold
		
        ld      a,'1'
        jp      set_attr
.nobold
        cp      2
        jr      z,dim
        cp      8
        jr      nz,nodim
.dim
        xor     a
        jp      set_attr
.nodim
        ld      hl,UNDRL
        cp      4
        jr      nz,nounderline
        ld      a,'4'
        jp      set_attr
.nounderline
        cp      24
        jr      nz,noCunderline
        xor     a
        jp      set_attr
.noCunderline
        ld      hl,BLINK
        cp      5
        jr      nz,noblink
        ld      a,'5'
        jp      set_attr
.noblink
        cp      25
        jr      nz,nocblink
        xor     a
        jp      set_attr
.nocblink
        ld      hl,INVRS
        cp      7
        jr      nz,noreverse
        ld      a,'7'
        jp      set_attr
.noreverse
        cp      27
        jr      nz,noCreverse
        xor     a
        jp      set_attr
.noCreverse
        cp      8
        jr      nz,noinvis


.setbk
        ret

.noinvis
        cp      28
        jr      nz,nocinvis
        ret

.nocinvis
        ret

.nofore
        ret


.set_attr
        ld      (hl),a
        call    clear_attrs_0

		ld      hl,INVRS

.next_attr
		ld      a,(hl)
		inc     a
		ret     z

		inc     hl
		dec     a
		jr      z,next_attr
		
		push    hl
		push    af
        ld      l,0x9B
        call    v1050_sendchar
		pop     af
        ld      l,a
        call    v1050_sendchar
        ld      l,'m'
        call    v1050_sendchar
		pop     hl
		
		jr      next_attr



clear_attrs:
		ld      hl,0
		ld      (INVRS),hl
		ld      (BOLD),hl
clear_attrs_0:
        ld      l,0x9B		; CSI (equals to "ESC [")
        call    v1050_sendchar
        ld      l,'m'
        jp      v1050_sendchar


.INVRS
        defb     0

.BLINK
        defb     0

.BOLD
        defb     0

.UNDRL
        defb     0

.ENDATTR
        defb     255
