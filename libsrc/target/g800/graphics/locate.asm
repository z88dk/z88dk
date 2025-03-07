    section smc_clib

    public  setx
    public  sety
    public  getpat

sety:
; set y position
; in:  h,l = x,y position
    push    af

    ld      a, 0xc0                     ; set startline to 0
    call    out58

    ld      a,h
    sub     30
    ld      e,a

    ld      d,0xb8
    jr      nc,left_half

    ; right half
    ld      d,0xbc
    ld      a,30                        ; mirror the x coordinates
    sub     e

left_half:
    add     30
    ld      e,a                         ; save the x coordinates

    ld      a, l
    sra     a
    sra     a
    sra     a                           ; a=y/8
    and     0x0f
    add     d                           ; left/right half offset
    ld      (setx_val+1),a
    pop     af

; TODO:  This needs to be fixed!!
    exx
	ld      bc,56h                       ; output data port, it must be survive through getpat and setx
    ;ld      bc,5Ah                       ; output data port, it must be survive through getpat and setx
    exx
	ld      bc,59h                       ; input data port, it must be survive through getpat and setx
    ;ld      bc,5Bh                       ; input data port, it must be survive through getpat and setx
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

      ; lower 4bit of x(e)
setx_val:
    ld      a, 0
    call    out58

      ; higher 4bit of x(e)
    ld      a, e
    sra     a
    sra     a
    sra     a
    sra     a
    and     0x0f
    or      0x10
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
    out     (0x54), a
    out     (0x58), a
    ret

