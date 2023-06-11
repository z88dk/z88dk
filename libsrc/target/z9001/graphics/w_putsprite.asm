;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Sept. 2016
;
; Robotron Z8001 high resolution KRT version
;

    SECTION smc_clib
    MODULE  __z9001_putsprite
    PUBLIC  putsprite
    PUBLIC  _putsprite
    EXTERN  w_pixeladdress

    EXTERN  __z9001_mode
    EXTERN  __z9001_attr
    EXTERN  __generic_putsprite
    EXTERN  KRT_BANK_SELECTOR
    EXTERN  KRT_PORT


    INCLUDE "graphics/grafix.inc"

; __gfx_coords: d,e (vert-horz)
; sprite: (ix)

.putsprite
._putsprite
    ld      a,(__z9001_mode)
    and     a
    jp      z,__generic_putsprite
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
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)  ; x and y __gfx_coords

    inc     hl
    ld      a,(hl)  ; and/or/xor mode
    ld      (ortype+1),a    ; Self modifying code
    ld      (ortype2+1),a   ; Self modifying code

    inc     hl
    ld      a,(hl)
    ld      (ortype),a      ; Self modifying code
    ld      (ortype2),a     ; Self modifying code

    ; @@@@@@@@@@@@
    ld      h,b
    ld      l,c
    ld      (oldx),hl
    ld      (cury),de
    call    w_pixeladdress
    ; ------
    ;ld		a,(hl)
    ; @@@@@@@@@@@@
    ld       c,a
    ld       hl,offsets_table
    ld       c,a
    ld       b,0
    add      hl,bc
    ld       a,(hl)
    ld       (wsmc1+1),a
    ld       (wsmc2+1),a
    ld       (_smc1+1),a

    ld      h,d
    ld      l,e                 ; display location from pixeladdress

    ld      a,(ix+0)
    cp      9
    jp      nc,putspritew

    ld       d,a
    ld       b,(ix+1)
._oloop  
    push     bc                ;Save # of rows
    ld       b,d               ;Load width
    ld       c,(ix+2)          ;Load one line of image
    inc      ix
._smc1   
    ld       a,1               ;Load pixel mask
._iloop  
    sla      c                 ;Test leftmost pixel
    jp       nc,_noplot        ;See if a plot is needed
    ld       e,a
.ortype
    nop     ; changed into nop / cpl
    nop    ; changed into and/or/xor (hl)
    ld       (hl),a
    call    docolour
    ld       a,e
._noplot 
    rrca

    jp       nc,_notedge       ;Test if edge of byte reached

    ;@@@@@@@@@@
    ;Go to next byte
    ;@@@@@@@@@@
    inc     hl
    ;@@@@@@@@@@

._notedge 
    djnz     _iloop

    push   de
    ;@@@@@@@@@@
    ;Go to next line
    ;@@@@@@@@@@
    ld      hl,(oldx)
    ld      de,(cury)
    inc     de
    ld      (cury),de
    call    w_pixeladdress
    ld      h,d
    ld      l,e
    ;@@@@@@@@@@
    pop     de
    pop      bc                ;Restore data
    djnz     _oloop
    pop     ix	;restore callers
    ld      a,KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    ret


.putspritew
    ld       d,a
    ld       b,(ix+1)        
.woloop  
    push     bc                ;Save # of rows
    ld       b,d               ;Load width
    ld       c,(ix+2)          ;Load one line of image
    inc      ix
.wsmc1    
    ld       a,1               ;Load pixel mask
.wiloop  
    sla      c                 ;Test leftmost pixel
    jp       nc,wnoplot         ;See if a plot is needed
    ld       e,a
.ortype2
    nop     ; changed into nop / cpl
    nop    ; changed into and/or/xor (hl)
    ld       (hl),a
    call    docolour
    ld       a,e
.wnoplot 
    rrca
    jp       nc,wnotedge        ;Test if edge of byte reached

;@@@@@@@@@@
;Go to next byte
;@@@@@@@@@@
    inc	hl
;@@@@@@@@@@

.wnotedge
.wsmc2   
    cp       1
    jp       z,wover_1

    djnz     wiloop

    push   de
    ;@@@@@@@@@@
    ;Go to next line
    ;@@@@@@@@@@
    ld      hl,(oldx)
    ld      de,(cury)
    inc     de
    ld      (cury),de
    call    w_pixeladdress
    ld      h,d
    ld      l,e
    ;@@@@@@@@@@
    pop     de

    pop     bc                ;Restore data
    djnz    woloop
    pop     ix
    ld      a,KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    ret


.wover_1 
    ld       c,(ix+2)
    inc      ix
    djnz     wiloop
    dec      ix

    push   de
    ;@@@@@@@@@@
    ;Go to next line
    ;@@@@@@@@@@
    ld      hl,(oldx)
    ld      de,(cury)
    inc     de
    ld      (cury),de
    call    w_pixeladdress
    ld      h,d
    ld      l,e
    ;@@@@@@@@@@
    pop     de

    pop     bc
    djnz    woloop
    pop     ix	;restore callers
    ld      a,KRT_BANK_SELECTOR
    out     (KRT_PORT),a
    ret


docolour:
    dec     h
    dec     h
    dec     h
    dec     h
    ld      a,(__z9001_attr)
    ld      (hl),a
    inc     h
    inc     h
    inc     h
    inc     h
    ret
    
    SECTION	rodata_clib
.offsets_table
        defb   1,2,4,8,16,32,64,128
    SECTION bss_clib
.oldx
         defw   0
.cury
         defw   0


