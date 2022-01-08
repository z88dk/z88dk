     INCLUDE     "graphics/grafix.inc"
     EXTERN pixeladdress
     EXTERN __gfx_coords
     EXTERN __rx78_ink


; RX78 has foreground and background planes
; For plotting we use the foreground planes, so the unplot
; reveals the default background colour - this is slightly different
; to other targets which show the *current* background colour

; Generic code to handle the pixel commands
; Define NEEDxxx before including

IF maxx <> 256
    ld      a,h
    cp      maxx
    ret     nc
ENDIF
    ld      a,l
    cp      maxy
    ret     nc
     
    ld      (__gfx_coords),hl

    push    bc     ;Save callers value
    call    pixeladdress          ;hl = address, a = pixel number
    ld      b,a
    ld      a,1
    jr      z, rotated      ; pixel is at bit 0...
.plot_position     
    rlca
    djnz    plot_position
     ; a = byte holding pixel mask
     ; hl = address
rotated:
IF NEEDplot|NEEDunplot|NEEDxor
    ld      e,a     ;Pixel to set
    cpl
    ld      d,a     ;Mask
ELSE
    ld      e,a     ;Pixel to set
ENDIF

IF NEEDplot|NEEDxor
    ld      a,(__rx78_ink)
    ld      c,a
ELIF NEEDunplot
    ld      c,0
ENDIF

    ; Switch to foreground plane
    ld      a,1
    out     ($f1),a      ;Reading planes
    ld      a,@00000001
    out     ($f2),a      ;Writing planes

IF NEEDplot|NEEDunplot
    ld      a,(hl)
    and     d
    rrc     c
    jr      nc,noset_blue
    or      e
noset_blue:
    ld      (hl),a
    ; Switch to green plane
    ld      a,2
    out     ($f1),a
    ld      a,@000000010
    out     ($f2),a
    ld      a,(hl)
    and     d
    rrc     c
    jr      nc,noset_green
    or      e
noset_green:
    ld      (hl),a
    ld      a,3
    out     ($f1),a
    ld      a,@00000100
    out     ($f2),a
    ld      a,(hl)
    and     d
    rrc     c
    jr      nc,noset_red
    or      e
noset_red:
    ld      (hl),a
ELIF NEEDxor
    ld      a,(hl)
    rrc     c
    jr      nc,noset_blue
    xor     e
noset_blue:
    ld      (hl),a
    ; Switch to green plane
    ld      a,2
    out     ($f1),a
    ld      a,@00000010
    out     ($f2),a
    ld      a,(hl)
    rrc     c
    jr      nc,noset_green
    xor     e
noset_green:
    ld      (hl),a
    ld      a,3
    out     ($f1),a
    ld      a,@00000100
    out     ($f2),a
    ld      a,(hl)
    rrc     c
    jr      nc,noset_red
    xor     e
noset_red:
    ld      (hl),a
ELIF NEEDpoint
    ld      d,(hl)
    ld      a,1
    out     ($f1),a
    ld      a,(hl)
    or      d
    ld      d,a
    ld      a,2
    out     ($f1),a
    ld      a,(hl)
    or      d
    and     e
got_point:
ENDIF
     pop     bc          ;Restore callers
     ret
