;
;        Fast background restore
;
;        MSX version
;
;        $Id: bkrestore.asm $
;

    SECTION smc_video_vdp
    
    
    EXTERN  bkpixeladdress

    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts
    EXTERN  swapgfxbk
    EXTERN  __graphics_end
    EXTERN  __tms9918_screen_mode

    INCLUDE "video/tms9918/vdp.inc"

    PUBLIC    bkrestore
    PUBLIC    _bkrestore
    PUBLIC    bkrestore_fastcall
    PUBLIC    _bkrestore_fastcall

.bkrestore
._bkrestore
    pop de
    pop hl
    push hl
    push de

.bkrestore_fastcall
._bkrestore_fastcall

       ld      a,(__tms9918_screen_mode)
       cp      2
       jr      z,dorender
       cp      4
       ret     nz
dorender:

; __FASTCALL__ : sprite ptr in HL
		push    ix                ;save callers        
		push    hl
		pop     ix
		call    swapgfxbk

		ld      h,(ix+2)
		ld      l,(ix+3)

		ld      a,(ix+0)
		ld      b,(ix+1)

		dec     a
		srl     a
		srl     a
		srl     a
		inc     a
		inc     a                ; INT ((Xsize-1)/8+2)
		ld      (rbytes+1),a

.bkrestores
		push    bc

		call    bkpixeladdress

.rbytes
		ld		a,0	; <-SMC!
.rloop
		ex      af,af
		call    l_tms9918_disable_interrupts
IF VDP_CMD < 0
		ld      a,e
		ld      (-VDP_CMD),a
		ld      a,d                ; MSB of video mem ptr
		and     @00111111        ; masked with "write command" bits
		or      @01000000
		ld      (-VDP_CMD),a
		ld      a,(ix+4)
		ld      (-VDP_DATA),a
ELSE
		ld      bc,VDP_CMD
		out     (c),e
		ld      a,d                ; MSB of video mem ptr
		and     @00111111        ; masked with "write command" bits
		or      @01000000
		out     (c),a
		ld      bc,VDP_DATA
		ld      a,(ix+4)
		out     (c),a
ENDIF
		call    l_tms9918_enable_interrupts
		ex      de,hl
		ld      bc,8
		add     hl,bc
		ex      de,hl 
		inc     ix
		ex      af,af
		dec     a
		jr      nz,rloop

		inc     l
		pop     bc
		djnz    bkrestores

		jp     __graphics_end        ;restore callers
