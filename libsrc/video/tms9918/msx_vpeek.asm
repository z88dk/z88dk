;
;        MSX specific routines
;
;        Improved functions by Rafael de Oliveira Jannone
;        Originally released in 2004 for GFX - a small graphics library
;
;        int msx_vpeek(int address);
;
;        Read the MSX video memory
;
;        $Id: msx_vpeek.asm,v 1.10 2016-06-16 19:30:25 dom Exp $
;

        SECTION code_clib
        PUBLIC  msx_vpeek
        PUBLIC  _msx_vpeek
        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts
        
        INCLUDE        "video/tms9918/vdp.inc"


msx_vpeek:
_msx_vpeek:
        ; (FASTCALL) -> HL = address
        ; enter vdp address pointer
        ld      a,l
        call    l_tms9918_disable_interrupts
		
IF VDP_CMD < 0
	ld	a,l
	ld	(-VDP_CMD),a
	ld	a,h
	and	@00111111
	ld	(-VDP_CMD),a
	ld	a,(-VDP_DATAIN)
ELSE
        ld      bc,VDP_CMD
        out     (c),l           ;LSB of video memory ptr
        ld      a,h		; MSB of video mem ptr
        and     @00111111	; masked with "write command" bits
        out     (c),a
        ld      bc,VDP_DATAIN
        in      a,(c)
ENDIF
        
        ld      h,0
        ld      l,a
        call    l_tms9918_enable_interrupts
        ret

