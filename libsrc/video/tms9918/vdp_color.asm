;
;	z88dk library: Generic VDP support code
;
;	int vdp_color(int foreground, int background, int border );
;
;	Change the color attributes (MSX style)
;
;	$Id: gen_color.asm,v 1.4 2016-07-14 17:44:17 pauloscustodio Exp $
;

    SECTION code_video_vdp
    PUBLIC	vdp_color
    PUBLIC	_vdp_color

    EXTERN	SETWRT
    EXTERN	FILVRM

    EXTERN	vdp_set_reg
    EXTERN  __tms9918_attribute
    EXTERN  __tms9918_colour_table
    EXTERN  __tms9918_border
    EXTERN  __tms9918_screen_mode
	
	;EXTERN	SCRMOD

	INCLUDE	"video/tms9918/vdp.inc"

vdp_color:
_vdp_color:
    push    ix		;save callers
    ld      ix,2
    add     ix,sp
    ld      a,(ix+6)	;foreground
    rlca
    rlca
    rlca
    rlca
    and     $F0
    ld      l,a
    ld      a,(ix+4)	;background
    and     15
    or      l
    ld      (__tms9918_attribute),a
    ld      h,a		;background + foreground
    ld      a,(__tms9918_screen_mode)
    push    af
    and     a
    jr      z,set_colour	;in 32x24 graphics mode
    ld      a,(ix+2)	;border
    and     15
    ld      (__tms9918_border),a
    or      l
    ld      h,a		;foreground + border
set_colour:
    ld      bc,7		;register
    push    bc
    ld      c,h		;value
    push    bc
    call    vdp_set_reg		;; This is wrong
    pop     af		;dump parameters
    pop     af
    pop     af		;Screen mode 
    and     a
    jr      nz,not_mode_0
    ld      a,(__tms9918_attribute)
    ld      hl,(__tms9918_colour_table)	;Colour table
    ld      bc,32
    call    FILVRM
not_mode_0:
    pop     ix		;restore callers
    ret

