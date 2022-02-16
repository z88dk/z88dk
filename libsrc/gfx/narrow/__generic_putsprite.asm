;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Sept 2003 - Stefano: Fixed bug for sprites wider than 8.
;
; Much More Generic version
; Uses plotpixel, respixel and xorpixel
;
;


IF !__CPU_INTEL__ & !__CPU_GBZ80__
    SECTION code_graphics
    PUBLIC    __generic_putsprite

    EXTERN    swapgfxbk
    EXTERN    __graphics_end

    EXTERN    plotpixel
    EXTERN    respixel
    EXTERN    xorpixel
    INCLUDE    "graphics/grafix.inc"

; __gfx_coords: h,l (vert-horz)
; sprite: (ix)

.__generic_putsprite
IF NEED_swapgfxbk = 1
    call    swapgfxbk
ENDIF  
      ld    hl,2   
      add    hl,sp
      ld    e,(hl)
      inc    hl
      ld    d,(hl)  ;sprite address
    push    ix
    push    de
    pop    ix

      inc    hl
      ld    e,(hl)
    inc    hl
      inc    hl
      ld    d,(hl)    ; x and y __gfx_coords

    inc    hl

      inc    hl
      ld    a,(hl)  ; and/or/xor mode

    ld    h,d
    ld    l,e
    
    cp    166    ; and(hl) opcode
    jr    z,doand

    cp    182    ; or(hl) opcode
    jp    z,door

    ; 182 - or
    ; 174 - xor

.doxor
    ld    a,(ix+0)    ; Width
    ld    b,(ix+1)    ; Height
.oloopx    push    bc    ;Save # of rows
    push    af

    ;ld    b,a    ;Load width
    ld    b,0    ; Better, start from zero !!

    ld    c,(ix+2)    ;Load one line of image

.iloopx    sla    c    ;Test leftmost pixel
    jr    nc,noplotx    ;See if a plot is needed

    pop    af
    push    af

    push    hl
    ;push    bc    ; this should be done by the called routine
    push    de
    ld    a,h
    add    a,b
    ld    h,a
    call    xorpixel
    pop    de
    ;pop    bc
    pop    hl

.noplotx

    inc    b    ; witdh counter
    
    pop    af
    push    af
    
    cp    b    ; end of row ?
    
    jr    nz,noblkx
    
    inc    ix
    ld    c,(ix+2)    ;Load next byte of image
    
    jr noblockx
    
.noblkx
    
    ld    a,b    ; next byte in row ?
    ;dec    a
    and    a
    jr    z,iloopx
    and    7
    
    jr    nz,iloopx
    
.blockx
    inc    ix
    ld    c,(ix+2)    ;Load next byte of image
    jr    iloopx

.noblockx

    inc    l

    pop    af
    pop    bc    ;Restore data
    djnz    oloopx
    ;pop    ix
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF


.doand
    ld    a,(ix+0)    ; Width
    ld    b,(ix+1)    ; Height
.oloopa    push    bc    ;Save # of rows
    push    af

    ;ld    b,a    ;Load width
    ld    b,0    ; Better, start from zero !!

    ld    c,(ix+2)    ;Load one line of image

.iloopa    sla    c    ;Test leftmost pixel
    jr    nc,noplota    ;See if a plot is needed

    pop    af
    push    af

    push    hl
    ;push    bc    ; this should be done by the called routine
    push    de
    ld    a,h
    add    a,b
    ld    h,a
    call    respixel
    pop    de
    ;pop    bc
    pop    hl

.noplota

    inc    b    ; witdh counter
    
    pop    af
    push    af
    
    cp    b    ; end of row ?
    
    jr    nz,noblka
    
    inc    ix
    ld    c,(ix+2)    ;Load next byte of image
    
    jr noblocka
    
.noblka
    
    ld    a,b    ; next byte in row ?
    ;dec    a
    and    a
    jr    z,iloopa
    and    7
    
    jr    nz,iloopa
    
.blocka
    inc    ix
    ld    c,(ix+2)    ;Load next byte of image
    jr    iloopa

.noblocka

    inc    l
    pop    af
      pop    bc    ;Restore data
      djnz    oloopa
    ;pop    ix
    jp    __graphics_end




.door
    ld    a,(ix+0)    ; Width
    ld    b,(ix+1)    ; Height
.oloopo    push    bc    ;Save # of rows
    push    af

    ;ld    b,a    ;Load width
    ld    b,0    ; Better, start from zero !!

    ld    c,(ix+2)    ;Load one line of image

.iloopo    sla    c    ;Test leftmost pixel
    jr    nc,noploto    ;See if a plot is needed

    pop    af
    push    af

    push    hl
    ;push    bc    ; this should be done by the called routine
    push    de
    ld    a,h
    add    a,b
    ld    h,a
    call    plotpixel
    pop    de
    ;pop    bc
    pop    hl

.noploto

    inc    b    ; witdh counter
    
    pop    af
    push    af
    
    cp    b    ; end of row ?
    
    jr    nz,noblko
    
    inc    ix
    ld    c,(ix+2)    ;Load next byte of image
    
    jr noblocko
    
.noblko
    
    ld    a,b    ; next byte in row ?
    ;dec    a
    and    a
    jr    z,iloopo
    and    7
    
    jr    nz,iloopo
    
.blocko
    inc    ix
    ld    c,(ix+2)    ;Load next byte of image
    jr    iloopo

.noblocko

    ;djnz    iloopo
    inc    l
    pop    af
    pop    bc    ;Restore data
    djnz    oloopo
    ;pop    ix
IF NEED_swapgfxbk
    jp      __graphics_end
ELSE
  IF !__CPU_INTEL__ & !__CPU_GBZ80__
    pop     ix
  ENDIF
    ret
ENDIF
ENDIF
