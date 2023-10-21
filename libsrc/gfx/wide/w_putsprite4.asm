;
; Sprite Rendering Routine
; original code by Patrick Davidson (TI 85)
; modified by Stefano Bodrato - Jan 2001
;
; Sept 2003 - Stefano: Fixed bug for sprites wider than 8.
; Apr 2017  - Stefano: Fixed bug for sprite pos coordinates wider than 255.
;

; SMC version (smaller than w_putsprite3) Uses plot, unplot, xorplot

;
;
; $Id: w_putsprite4.asm $
;

  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION smc_clib
        PUBLIC  putsprite
        PUBLIC  _putsprite
        PUBLIC  ___putsprite

        EXTERN  plot
        EXTERN  unplot
        EXTERN  xorplot


; __gfx_coords: h,l (vert-horz)
; sprite: (ix)

putsprite:
_putsprite:
___putsprite:
        ld      hl, 2
        add     hl, sp
        ld      e, (hl)
        inc     hl
        ld      d, (hl)                 ;sprite address

        push    ix                      ; preserve IX

        push    de
        pop     ix

        inc     hl
        ld      e, (hl)
        inc     hl
        ld      d, (hl)
        inc     hl
        ld      c, (hl)
        inc     hl
        ld      b, (hl)                 ; x and y __gfx_coords
        ld      (oldx), bc

        inc     hl
        ld      a, (hl)                 ; and/or/xor mode

;--------------------------------------

        ld      hl, plot
        ld      (smc_fn+1), hl

        cp      182                     ; or(hl) opcode
        jr      z, door

        ld      hl, unplot
        ld      (smc_fn+1), hl

        cp      166                     ; and(hl) opcode
        jr      z, door

doxor:
    ; 174 - xor
        ld      hl, xorplot
        ld      (smc_fn+1), hl


;--------------------------------------

door:
        ld      a, (ix+0)               ; Width
        ld      b, (ix+1)               ; Height
oloopo:
        push    bc                      ;Save # of rows
        push    af

        ld      hl, (oldx)              ;;

    ;ld    b,a    ;Load width
        ld      b, 0                    ; Better, start from zero !!

        ld      c, (ix+2)               ;Load one line of image

iloopo:
        sla     c                       ;Test leftmost pixel
        jr      nc, noploto             ;See if a plot is needed

        push    bc
        push    hl
        push    de

smc_fn:
        call    plot

        pop     de
        pop     hl
        pop     bc


noploto:

        inc     b                       ; witdh counter
        inc     hl                      ;;

        pop     af
        push    af

        cp      b                       ; end of row ?

        jr      nz, noblko

        inc     ix
        ld      c, (ix+2)               ;Load next byte of image

        jr      noblocko

noblko:

        ld      a, b                    ; next byte in row ?
    ;dec    a
        and     a
        jr      z, iloopo
        and     7

        jr      nz, iloopo

blocko:
        inc     ix
        ld      c, (ix+2)               ;Load next byte of image
        jr      iloopo

noblocko:

    ;pop hl
    ;inc    l
        inc     de

        pop     af
        pop     bc                      ;Restore data
        djnz    oloopo

    ;ret
        ld      a, 1                    ; Restore INK color

        pop     ix                      ; restore IX before exiting

        ret

;----------------------------------------------


        SECTION bss_graphics
oldx:
        defw    0

  ENDIF
