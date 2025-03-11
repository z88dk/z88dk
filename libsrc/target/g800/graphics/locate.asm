
IF FORg850
    section code_graphics
ELSE
    section smc_clib
ENDIF

    public  setx
    public  sety
    public  getpat

    INCLUDE "graphics/grafix.inc"

sety:
; set y position
; in:  h,l = x,y position
    push    af

IF FORg850

;    ld      a, 0x40                     ; set startline to 0
;    call    outp_disp

    ld      a, l
    rra
    rra
    rra                               ; a=y/8
    and     0x0f
    or      0xb0
    call    outp_disp
    exx
    ld      bc,41h                      ; output data port, it must be survive through getpat and setx
    exx
    ld      bc,41h                      ; input data port, it must be survive through getpat and setx

ELSE

;IF FORg815
;busy_check_0:
;    in      a, (0x55)
;    and     0x80
;    jp      nz, busy_check_0
;    ld      a, 0xc0                     ; set scroll startline to 0
;    out     (0x54), a
;ENDIF
;busy_check_1:
;    in      a, (0x59)
;    and     0x80
;    jp      nz, busy_check_1
;    ld      a, 0xc0                     ; set scroll startline to 0
;    out     (0x58), a

    ld      a,h
    sub     maxx/2                      ; check if x is in the left half of the display

    ld      a,0xb8
    ld      (setx_half+1),a
    jr      c,left_half

    ; right half
    ld      a,0xbc
    ld      (setx_half+1),a
    ld      a,maxx                      ; mirror the x coordinates
    sub     h                           ; adjust x
    ld      h,a
left_half:

IF FORe200

    exx
    ld      bc,5Ah                       ; output data port, it must be survive through getpat and setx
    exx
    ld      bc,5Bh                       ; input data port, it must be survive through getpat and setx

ELSE

    ld      a,h
    sub     60
    jr      c,first_blocks_a
    ld      h,a
first_blocks_a:
    ld      a,54h
    jr      c,first_blocks_b
    ld      a,58h
first_blocks_b:
    ld      (x_port+1),a
    inc     a
    ld      (busy_check+1),a
    inc     a
    exx
    ld      b,0
    ld      c,a
    exx
    inc     a
    ld      b,0
    ld      c,a

ENDIF
ENDIF
    pop     af
    ret


; make pattern
; in: l = y position
; out d = pattern
getpat:
    ld      a, l

    ld      d, 0x1
    and     0x07                        ;a=y%8
;IF !FORg850
;    ret     z
;ENDIF
    inc     a
loop_shift:
    dec     a
    ret     z
    sla     d
    jp      loop_shift


; set x position
setx:
    push    af

IF FORg850

      ; lower 4bit of x(h)
    ld      a, h
    and     0x0F
    call    outp_disp

      ; higher 4bit of x(h)
    ld      a, h
    rra
    rra
    rra
    rra
    and     0x0f
    or      0x10
    call    outp_disp

ELSE

    ; G815 and E200
    ld      a, l
    rra
    rra
    rra                           ; a=y/8
    and     0x0f
setx_half:
    or      0xb8                  ; SMC
;    and     0xbf
    call    outp_disp

      ; higher 4bit of x(e)
    ld      a, h
    add     0x40
    call    outp_disp

ENDIF

    pop     af
    ret

; write to lcd driver
outp_disp:
    push    af
busy_check:
IF FORg850
    in      a, (0x40)
ELSE
    in      a, (0x59)
ENDIF
    and     0x80
    jp      nz, busy_check
    pop     af
x_port:
IF FORg850
    out     (0x40), a
ELSE
    out     (0x58), a
ENDIF
    ret

