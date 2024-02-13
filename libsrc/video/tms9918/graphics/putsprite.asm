;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2009
;
; MSX version
;
;
; $Id: putsprite.asm $
;

    SECTION smc_video_vdp
    PUBLIC  putsprite
    PUBLIC  _putsprite
    EXTERN  __tms9918_pixeladdress
    EXTERN  __tms9918_pixelbyte
    EXTERN  l_tms9918_disable_interrupts
    EXTERN  l_tms9918_enable_interrupts
    EXTERN  __tms9918_attribute
    EXTERN  __tms9918_screen_mode

    EXTERN  __graphics_end
    EXTERN  __generic_putsprite

    INCLUDE	"graphics/grafix.inc"
    INCLUDE	"video/tms9918/vdp.inc"


; __gfx_coords: d,e (vert-horz)
; sprite: (ix)


.putsprite
._putsprite
    ld      a,(__tms9918_screen_mode)
    cp      2
IFDEF V9938
    jr      z,dorender
    cp      4
ENDIF
    jp      nz,__generic_putsprite
dorender:
    push    ix		;save callers
    ld      hl,4
    add     hl,sp
    ld      e,(hl)
    inc     hl
    ld      d,(hl)  ; sprite address
    push    de
    pop     ix

    inc     hl
    ld      e,(hl)  
    inc     hl
    inc     hl
    ld      d,(hl)	; x and y __gfx_coords

    inc     hl

    inc     hl
    ld      a,(hl)  ; and/or/xor mode
    ld      (ortype+1),a	; Self modifying code
    ld      (ortype2+1),a	; Self modifying code

    inc     hl
    ld      a,(hl)
    ld      (ortype),a	; Self modifying code
    ld      (ortype2),a	; Self modifying code


    ld      h,d
    ld      l,e

    ld      (actcoord),hl	; save current coordinates

    call    __tms9918_pixeladdress

    ld       hl,offsets_table
    ld       c,a
    ld       b,0
    add      hl,bc
    ld       a,(hl)
    ld       (wsmc1+1),a
    ld       (wsmc2+1),a
    ld       (_smc1+1),a
    ld      h,d
    ld      l,e


    ld      a,(ix+0)
    cp      9
    jr      nc,putspritew

    ld       d,(ix+0)
    ld       b,(ix+1)
._oloop  
    push     bc                ;Save # of rows
    ld       b,d               ;Load width
    ld       c,(ix+2)          ;Load one line of image
    inc      ix
._smc1   
    ld       a,1               ;Load pixel mask
._iloop
    push     hl			;*
    ld       hl,__tms9918_pixelbyte		;*
    sla      c                 ;Test leftmost pixel
    jr       nc,_noplot        ;See if a plot is needed
    ld       e,a
.ortype
    nop	; changed into nop / cpl
    nop	; changed into and/or/xor (hl)
    ld       (hl),a
    ld       a,e
._noplot rrca
    pop      hl			;*
    call     c,_edge        ;If edge of byte reached, go to next byte
    djnz     _iloop

; ---------
    call     _row
; ---------

    pop      bc                ;Restore data
    djnz     _oloop
.putsprite_exit
    pop     ix
    ret

.putspritew
    ld       d,(ix+0)
    ld       b,(ix+1)        
.woloop  
    push     bc                ;Save # of rows
    ld       b,d               ;Load width
    ld       c,(ix+2)          ;Load one line of image
    inc      ix
.wsmc1    
    ld       a,1               ;Load pixel mask
.wiloop
    push     hl			;*
    ld       hl,__tms9918_pixelbyte		;*
    sla      c                 ;Test leftmost pixel
    jr       nc,wnoplot         ;See if a plot is needed
    ld       e,a

.ortype2
    nop	; changed into nop / cpl
    nop	; changed into and/or/xor (hl)
    ld       (hl),a
    ld       a,e
.wnoplot rrca
    pop      hl			;*
    call     c,_edge        ;If edge of byte reached, go to next byte
.wsmc2   
    cp       1
    jr       z,wover_1
    djnz     wiloop

	; ---------
    call     _row
	; ---------

    pop      bc                ;Restore data
    djnz     woloop
    jr       putsprite_exit
	

.wover_1 
    ld       c,(ix+2)
    inc      ix
    djnz     wiloop
    dec      ix

	; ---------
    call     _row
	; ---------

    pop      bc
    djnz     woloop
    jr       putsprite_exit

	SECTION  code_graphics
; Edge of byte reached, save its content,
; increment video ptr, and get new byte.
._edge
    push     af
;**************
    call	l_tms9918_disable_interrupts
IF VDP_CMD < 0
    ld      a,l
    ld      (-VDP_CMD),a
    ld      a,h
    and     @00111111
    or      @01000000
    ld      (-VDP_CMD),a
    ld      a,(__tms9918_pixelbyte)
    ld      (-VDP_DATA),a
    ; And now the attribute
    push    hl		;11	- delay a little
    pop     hl		;10
    ld      a,l		;4
    ld      (-VDP_CMD),a
    ld      a,h
    add     $20
    and     @00111111
    or      @01000000
    ld      (-VDP_CMD),a
    ld      a,(__tms9918_attribute)
    ld      (-VDP_DATA),a
ELSE
    push    bc
    ld      bc,VDP_CMD
    out     (c),l           ;LSB of video memory ptr
    ld      a,h		; MSB of video mem ptr
    and     @00111111	; masked with "write command" bits
    or      @01000000
    out     (c),a
    ld      a,(__tms9918_pixelbyte)
    ld      bc,VDP_DATA
    out     (c),a
    ; And now the attribute
    ld      bc,VDP_CMD	;10
    ld      bc,VDP_CMD	;10 - delay a little
    ld      a,l         ;4
    out     (c),a
    ld      a,h
    add     $20
    and     @00111111
    or      @01000000
    out     (c),a
    ld      a,(__tms9918_attribute)
    ld      bc,VDP_DATA
    out     (c),a
    pop     bc
ENDIF
    call    l_tms9918_enable_interrupts
;**************
    ld       a,8
    add      l
    ld       l,a
    ;jr       nc,nozh
    ;inc      h
;.nozh
    ;inc      hl                ;Go to next byte
;**************
    call    l_tms9918_disable_interrupts
IF VDP_CMD < 0
    ld      a,l
    ld      (-VDP_CMD),a
    ld      a,h
    and     @00111111
    ld      (-VDP_CMD),a
    ld      a,(-VDP_DATAIN)
ELSE
    push    bc
    ld      bc,VDP_CMD
    out     (c),l
    ld      a,h		; MSB of video mem ptr
    and     @00111111	; masked with "read command" bits
    out     (c),a
    ld      bc,VDP_DATAIN
    ld      bc,VDP_DATAIN  ;delay
    nop
    in      a,(c)
    pop     bc
ENDIF
    ld       (__tms9918_pixelbyte),a
    call	l_tms9918_enable_interrupts
;**************
    pop      af
    ret

._row
    push    af
;**************
    call    l_tms9918_disable_interrupts
IF VDP_CMD < 0
    ld      a,l
    ld      (-VDP_CMD),a
    ld      a,h
    and     @00111111
    or      @01000000
    ld      (-VDP_CMD),a
    ld      a,(__tms9918_pixelbyte)
    ld      (-VDP_DATA),a
    ld      a,l
    ld      (-VDP_CMD),a
    ld      a,h
    add     $20
    and     @00111111
    or      @01000000
    ld      (-VDP_CMD),a
    ld      a,(__tms9918_attribute)
    ld      (-VDP_DATA),a
ELSE
    push    bc
    ld      bc,VDP_CMD
    out     (c),l           ; LSB of video memory ptr
    ld      a,h		; MSB of video mem ptr
    and     @00111111	; masked with "write command" bits
    or      @01000000
    out     (c),a
    ld      bc,VDP_DATA
    ld      a,(__tms9918_pixelbyte)
    out     (c),a
    ld      bc,VDP_CMD
    ld      bc,VDP_CMD	;delay
    nop
    out     (c),l
    ld      a,h		; MSB of video mem ptr
    add     $20
    and     @00111111	; masked with "write command" bits
    or      @01000000
    out     (c),a
    ld      bc,VDP_DATA
    ld      a,(__tms9918_attribute)
    out     (c),a
    pop     bc
ENDIF
    call    l_tms9918_enable_interrupts
;**************
    push    de
    ld      hl,(actcoord)
    inc     l
    ld      (actcoord),hl
    call    __tms9918_pixeladdress
    ld      h,d
    ld      l,e
    pop     de
    pop     af
    ret
        
    SECTION	rodata_video_vdp
.offsets_table
    defb    1,2,4,8,16,32,64,128

    SECTION data_video_vdp
.actcoord
     defw	0
