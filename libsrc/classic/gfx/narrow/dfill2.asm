;     Z88DK Small C+ Graphics Functions
;     Fills a screen area
;    Original code by Massimo Morra (Thanks!)
;    Ported by Stefano Bodrato
;
;    Feb 2000 - Platform dependent stack usage
;      Stack usage should be _GFX_MAXY*8 (512 bytes for the Z88)
;
;    Since some platform (expecially the TI83) has very little stack space,
;    we undersize it; this will cause a crash if a big area is filled.
;
;    GENERIC VERSION
;   IT DOESN'T MAKE USE OF ALTERNATE REGISTERS
;   IT IS BASED ON "pointxy" and "plotpixel"
;   (dfill at the moment is Z80 only and uses pixeladdress)
;
;    $Id: dfill2.asm $
;


; TODO: the Intel 8080 version is still broken
;       it completes the picture but misses the buffer terminator and overflows (crashing)


    SECTION code_graphics

    INCLUDE "classic/gfx/grafix.inc"

    PUBLIC  do_fill
    EXTERN  pointxy
    EXTERN  plotpixel


IF  __CPU_INTEL__|__CPU_GBZ80__

SWAP_FILLPTR MACRO
    push    de
    ex      de,hl         ; de=prev
    ld      hl,(fillptr)  ; hl=new
    ex      de,hl         ; de=new, hl=prev
    ld      (fillptr),hl  ; (filptr)=prev
    ex      de,hl         ; hl=new
    pop     de
ENDM

ENDIF



;ix points to the table on stack (above)

;Entry:
;     e=x0 d=y0

do_fill:
    ld      (spsave),sp
    ld      hl, -_GFX_MAXY*3      ; create buffer 1 on stack
    add     hl, sp                ; The stack size depends on the display height.
    ld      sp, hl                ; The worst case is when we paint a blank

IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    hl                    ; display starting from the center.
    pop     ix
ELSE
    ld      (fillptr),hl
ENDIF

    ld      (hl), d
    inc     hl
    ld      (hl), e
    inc     hl
    ld      (hl), 255
    ld      hl, -_GFX_MAXY*3      ; create buffer 2 on stack
    add     hl, sp
    ld      sp, hl

loop:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    push    ix
    push    hl
ELSE
    push    hl
    SWAP_FILLPTR
ENDIF
    call    cfill
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    pop     ix
    pop     hl
ELSE
    pop     hl                    ; prev ptr
    SWAP_FILLPTR
ENDIF

    push    de
    pop     af

    ;;ex    af,af                 ; Restore the Z flag
    ;;push    af
    ;;ex    af,af
    ;;pop    af

    jr      nz, loop


    ld      hl,(spsave)
    ld      sp, hl
    ret

;    ld      hl, _GFX_MAXY*6       ; restore the stack pointer (parm*2)
;    add     hl, sp
;    ld      sp, hl
;    ret

cfill:
    ;sub    a,a    ; Reset the Z flag
    ;ex    af,af    ; and save it

    xor     a
    push    af
    pop     de

next:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    ld      a, (ix+0)
    cp      255                   ; stopper ?
    ret     z                     ; return
    ld      b, a
    ld      c, (ix+1)
ELSE
    ld      a, (hl)
    cp      255                   ; stopper ?
    ret     z                     ; return
    ld      b, a
    inc     hl
    ld      a, (hl)
    ld      c, a
    dec     hl
ENDIF

    push    bc

    or      a
    jr      z, l1

    dec     b
    call    doplot
    pop     bc
    push    bc

l1:
    ld      a, b

    cp      _GFX_MAXY-1
    jr      z, l2

    inc     b
    call    doplot
    pop     bc
    push    bc

l2:

    ld      a, c
    or      a
    jr      z, l3

    dec     c
    call    doplot

l3:
    pop     bc

    ld      a, c
    cp      _GFX_MAXX-1
    jr      z, l4

    inc     c
    call    doplot

l4:
IF  !__CPU_INTEL__&!__CPU_GBZ80__
    inc     ix
    inc     ix
ELSE
    inc     hl
    inc     hl
ENDIF
    jr      next

doplot:
    push    bc
    push    hl
    ld      l, b
    ld      h, c

    ;call    pixeladdress         ; bc must be saved by pixeladdress !
    push    de
    call    pointxy
    pop     de
    pop     hl

    jr      z, dontret
    pop     af
    ret
dontret:

    or      b                     ; Z flag set...

    push    af

    push    hl
    ld      l, b
    ld      h, c
    call    plotpixel
    pop     hl

    pop     de

IF  __CPU_INTEL__|__CPU_GBZ80__
    SWAP_FILLPTR
ENDIF
    pop     bc
    ld      (hl), b
    inc     hl
    ld      (hl), c
    inc     hl
    ld      (hl), 255
IF  __CPU_INTEL__|__CPU_GBZ80__
    SWAP_FILLPTR
ENDIF

    ;ex    af,af                  ; Save the Z flag

    xor     a

    ret


    SECTION bss_graphics

spsave:
    defw    0

IF  __CPU_INTEL__|__CPU_GBZ80__
fillptr:
    defw    0
ENDIF
