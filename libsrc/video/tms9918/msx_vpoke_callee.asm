;
;        MSX specific routines
;        by Stefano Bodrato, 29/11/2007
;
;        void msx_vpoke(int address, int value);
;
;        Improved functions by Rafael de Oliveira Jannone
;        Originally released in 2004 for GFX - a small graphics library
;
;        $Id: msx_vpoke_callee.asm$
;

        SECTION code_clib
        PUBLIC  msx_vpoke_callee
        PUBLIC  _msx_vpoke_callee
        
        PUBLIC  msx_vpoke_direct

        PUBLIC asm_msx_vpoke
        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts

        INCLUDE "video/tms9918/vdp.inc"
        

msx_vpoke_callee:
_msx_vpoke_callee:

        pop        bc
        pop        de        ; value
        pop        hl        ; VRAM address
        push        bc
        
.asm_msx_vpoke
        ld        a,e
msx_vpoke_direct:
        ex		af,af
        call    l_tms9918_disable_interrupts
        ; enter vdp address pointer
		
IF VDP_CMD < 0
	ld	a,l
	ld	(-VDP_CMD),a
	ld	a,h
	and	@00111111
	or	@01000000
	ld	(-VDP_CMD),a
	ex	af,af
	ld	(-VDP_DATA),a
ELSE
        ld      bc,VDP_CMD
        out     (c),l           ;LSB of video memory ptr
        ld      a,h		; MSB of video mem ptr
        and     @00111111	; masked with "write command" bits
        or      @01000000
        out     (c),a
        ex      af,af
        ld      bc,VDP_DATA
        out     (c),a
ENDIF

        call    l_tms9918_enable_interrupts
        ret
        
