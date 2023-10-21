;
; Getsprite - Picks up a sprite from display with the given size
; by Stefano Bodrato - 2019
;
; The original putsprite code is by Patrick Davidson (TI 85)
;
; Generic version (just a bit slow)
;
;
; $Id: getsprite2.asm $
;


  IF    !__CPU_INTEL__&!__CPU_GBZ80__
        SECTION smc_clib

        PUBLIC  getsprite
        PUBLIC  _getsprite
        PUBLIC  ___getsprite
        PUBLIC  getsprite_sub

        EXTERN  pointxy

        EXTERN  swapgfxbk
        EXTERN  __graphics_end
        INCLUDE "graphics/grafix.inc"


; __gfx_coords: d,e (vert-horz)
; sprite: (ix)



getsprite:
_getsprite:
___getsprite:

        push    ix

        ld      hl, 4
        add     hl, sp
        ld      e, (hl)
        inc     hl
        ld      d, (hl)                 ; sprite address
        push    de
        pop     ix

        inc     hl
        ld      e, (hl)
        inc     hl
        inc     hl
        ld      d, (hl)                 ; x and y __gfx_coords


getsprite_sub:
        ld      h, d                    ; X
        ld      l, e                    ; Y

        dec     h
        ld      c, h                    ; keep copy of X position

    IF  NEED_swapgfxbk=1
        call    swapgfxbk
    ENDIF

        ld      b, (ix+0)               ; x size (iloop)
        ld      d, (ix+1)               ; y size (oloop)

        ld      e, $fe                  ; trailing byte for "set 7,.." instruction

        ld      a, 7
        and     b                       ; SMC for an extra the byte boundary check if the sprite edge is not exactly on a byte
        jr      z, skip_inc             ; NOP
        ld      a, $23                  ; INC IX
skip_inc:
        ld      (inc_smc+1), a
        inc     b

oloop:
        xor     a
        ld      (ix+2), a
        push    de
        push    bc                      ; keep copy of counters

        ld      (nopoint-1), a
        ld      e, a

iloop:
        push    bc
        push    de
        push    hl
        call    pointxy
        pop     hl
        pop     de

        jr      z, nopoint
        set     7, (ix+2)               ; SMC (23 T)
nopoint:

        ld      a, e
        sub     8                       ; next bit (count 7 to 0)
        cp      $c6-8                   ; trailing byte for "set 0,.." instruction  (rightmost bit)
        jr      nc, next_bit

        inc     ix                      ; next byte in the sprite data
        xor     a
        ld      (ix+2), a
        ld      a, $fe                  ; trailing byte for "set 0,.." instruction

next_bit:
        ld      (nopoint-1), a
        ld      e, a

        inc     h                       ; increment X

        pop     bc                      ;
        djnz    iloop

        ld      a, $fe                  ; trailing byte for "set 7,.." instruction
        cp      e
        jr      z, noinc
inc_smc:
        inc     ix                      ; next byte in the sprite data
noinc:

        pop     bc                      ; restore counters
        pop     de

        ld      h, c                    ; reset X
        inc     l                       ; increment Y

        dec     d
        jr      nz, oloop

    IF  NEED_swapgfxbk
        jp      __graphics_end
    ELSE
      IF    !__CPU_INTEL__&!__CPU_GBZ80__
        pop     ix
      ENDIF
        ret
    ENDIF
  ENDIF
