;
;        Fast background area save
;
;        MSX version
;
;        $Id: bksave.asm,v 1.7 2016-07-02 09:01:36 dom Exp $
;

        SECTION smc_clib
        
        PUBLIC  bksave
        PUBLIC  _bksave
        PUBLIC  bkpixeladdress
        EXTERN  l_tms9918_disable_interrupts
        EXTERN  l_tms9918_enable_interrupts
        EXTERN  swapgfxbk
        EXTERN  __graphics_end

        INCLUDE "video/tms9918/vdp.inc"

        
.bksave
._bksave
        push    ix        ;save callers
        call    swapgfxbk
        ld      hl,4
        add     hl,sp
        ld      e,(hl)
        inc     hl
        ld      d,(hl)  ;sprite address
        push    de
        pop     ix

        inc     hl
        ld      e,(hl)  
        inc     hl
        inc     hl
        ld      d,(hl)        ; x and y __gfx_coords

        ld      h,d        ; current x coordinate
        ld      l,e        ; current y coordinate

        ld      (ix+2),h
        ld      (ix+3),l

        ld      a,(ix+0)
        ld      b,(ix+1)

        dec     a
        srl     a
        srl     a
        srl     a
        inc     a
        inc     a                ; INT ((Xsize-1)/8+2)
        ld      (rbytes+1),a

.bksaves
        push    bc
        call    bkpixeladdress
		
.rbytes
        ld      a,0	; <-SMC!

.rloop
        ex      af,af
;-------
        call    l_tms9918_disable_interrupts
IF VDP_CMD < 0
        ld      a,e
        ld      (-VDP_CMD),a
        ld      a,d                ; MSB of video mem ptr
        and     @00111111        ; masked with "read command" bits
        ld      (-VDP_CMD),a
        ld      a,(-VDP_DATAIN)
ELSE
        ld      bc,VDP_CMD
        out     (c),e
        ld      a,d                ; MSB of video mem ptr
        and     @00111111        ; masked with "read command" bits
        out     (c),a
        ld      bc,VDP_DATAIN
        in      a,(c)
ENDIF
        ld      (ix+4),a
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
        djnz    bksaves
		
        jp      __graphics_end


.bkpixeladdress
        push    hl
        ld      b,l                ; Y
        ld      a,h                ; X
        and     @11111000
        ld      l,a
        ld      a,b                ; Y
        rra
        rra
        rra
        and     @00011111
        ld      h,a                ; + ((Y & @11111000) << 5)
        ld      a,b                ; Y
        and     7
        ld      e,a
        ld      d,0
        add     hl,de                ; + Y&7
        ex      de,hl
        pop     hl
        ret
