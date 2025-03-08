    section smc_clib

    public  setx
    public  sety
    public  getpat

sety:
; set y position
; in:  h,l = x,y position
    push    af

    ld      a, 0xc0                     ; set scroll startline to 0
    call    out58

    ld      a,h
    sub     60                          ; check if x is in the left half of the display

    ld      a,0xb8
	ld		(setx_half+1),a
    jr      c,left_half

    ; right half
    ld      a,0xbc
	ld		(setx_half+1),a
    ld      a,120                       ; mirror the x coordinates
    sub     h                           ; adjust x
	ld      h,a
	
left_half:
    pop     af


; NOTE:  This is valid for the E200/G, NOT for the G815!
    exx
    ld      bc,5Ah                       ; output data port, it must be survive through getpat and setx
    exx
    ld      bc,5Bh                       ; input data port, it must be survive through getpat and setx
    ret


; make pattern
; in: l = y position
; out d = pattern
getpat:
    ld      a, l
    and     0x07                        ;a=y%8
    inc     a
    ld      d, 0x1
loop_shift:
    dec     a
    ret     z
    sla     d
    jp      loop_shift


; set x position
setx:
    push    af

    ld      a, l
    rra
    rra
    rra                           ; a=y/8
    and     0x0f
setx_half:
    add     0
    call    out58

      ; higher 4bit of x(e)
    ld      a, h
    add     0x40
    call    out58

    pop     af
    ret

; write to lcd driver
out58:
    push    af
loop59:
    in      a, (0x59)
    and     0x80
    jp      nz, loop59
    pop     af
;    out     (0x54), a
x_port:
    out     (0x58), a
    ret

