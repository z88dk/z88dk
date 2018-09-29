    SECTION         code_clib

    PUBLIC draw_main
    EXTERN last_pos

; draw line routine based on Bresenham's algorithm
;
; input:
;     de: x0/y0
;     hl: x1/y1
;     iy: plot routine address

;----------------------------------------------------------
draw_main:

    ; convert from 2nd/3rd quadrant to 1st/4th quadrant
    call conv_quad

    ; store x1/y1
    ld a,h
    ld (x1_),a
    ld a,l
    ld (y1_),a

    ; b = dx
    ld a,h
    sub d
    ld b,a

    ; c =dy
    ld a,l
    sub e
    ld c,a

    ; if dy<0 goto aminus
    cp 0
    jp m, aminus

    ; signy = 1
    ld a,1
    ld (signy_),a
    jp ext_signy

aminus:
    ; signy = -1
    ld a,-1
    ld (signy_),a

    ; dy= signy*dy
    ld a,c
    neg
    ld c,a

ext_signy:
    ; if dy>dx goto over45
    ld a,b
    sub c
    jp m, over45

;-------------------------------------
; under 45 degrees at 1st/4th quadrant
;-------------------------------------

under45:

; d0 = 2 * dy;
    sla c
    ld a,c
    ld (d0_),a

; D = d0 - dx;
    sub b
    ld (D_),a

; plot(x0,y0)
    ld h,d
    ld l,e
    call myplotpixel

;    for (x = x0 + 1; x <= x1; x++) {
    inc h ; x=x0+1

loop_under45:
; if (x1<x){goto exit_draw}
    ld a,(x1_)
    cp h
    jp m, exit_draw


;      if (D <= 0) goto plot45
    ld a,(D_)
    cp 0
    jp m, plot45
    jp z, plot45

;        y = y + signy;
    ld a,l
    ld IX,signy_
    add a,(IX)
    ld l,a

;        D -= 2 * dx;
    ld d,b;
    sla d ; 2*dx
    ld a,(D_)
    sub d
    ld (D_),a

plot45:
;      D += d0;
    ld a,(D_)
    ld IX,d0_
    add a,(IX)
    ld (D_),a
     call myplotpixel

    inc h
    jp loop_under45

;-------------------------------------
; over 45 degrees at 1st/4th quadrant
;-------------------------------------

over45:
; d0 = 2 * dx;
    sla b
    ld a,b
    ld (d0_),a

; D = d0 - dy;
    sub c
    ld (D_),a;

; plot(x0,y0) ; x=x0;
    ld h,d
    ld l,e
    call myplotpixel

;    for (y = y0 + 1; signy * (y - y1) <= 0; y += signy) {
    inc l ; y=y0+1

loop_over45:

ext_y_p_signy:
    ld a,(y1_)
    sub l
    push af ; a= y1-y

    ld a,(signy_)
    cp 0
    jp m, aminus2 ;if a<0 goto aminus2
    pop af
    jp cmp

aminus2:
    pop af
    neg

cmp:
    cp 0
    jp m, exit_draw ; if (signy*(y-y1)>0){goto exit_draw}

    ld a,(D_)
    cp 0

;      if (D <= 0)  goto plot_over45
    jp m, plot_over45
    jp z, plot_over45

;        x = x + 1
    inc h

;        D -= 2 * dy;
    ld d,c;
    sla d ; 2*dy
    ld a,(D_)
    sub d
    ld (D_),a

plot_over45:
;      D += d0;
    ld a,(D_)
    push IX
    ld IX,d0_
    add a,(IX)
    pop IX
    ld (D_),a
    call myplotpixel

; y+=signy
    ld a,(signy_)
    cp 0
    jp m, aminus1 ;if a<0 goto aminus1
    inc l ; y++ (y+=signy)
    jp ext_y_p_signy

aminus1:
    dec l ;y-- (y+=signy)
    jp loop_over45
;-------

exit_draw:
  ret

myplotpixel:
  push bc
  ld bc, exitplotpixel
  push bc
  jp (iy)
;nop
exitplotpixel:
  pop bc
  ret


; convert from 2nd/3rd quadrant to 1st/4th quadrant
conv_quad:
  ld a,d
  cp h
  ret m          ; return if x0<x1
  ex de,hl
  ret

    SECTION         bss_clib

signy_:
  defb 0

x1_:
  defb 0
y1_:
  defb 0
x_:
  defb 0
D_:
  defb 0
d0_:
  defb 0

