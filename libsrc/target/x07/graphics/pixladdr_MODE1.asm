
SECTION code_clib
PUBLIC  pixladdr_MODE1
EXTERN  __x07_mode1_screen

; This display is 96x32 pixels
; Entry: l = y (0-31)
;        h = x (0-95)
; Exit:  hl = screen address
;         a = pixel count
pixladdr_MODE1:
    ld      a,h
    ld      h,0
    ;  * 16
    add     hl,hl
    add     hl,hl
    add     hl,hl
    add     hl,hl
    ld      d,a
    rrca
    rrca
    rrca
    and     15
    ld      e,a
    ld      a,d
    ld      d, 0
    add     hl, de
    ld      de,__x07_mode1_screen
    add     hl,de
    and     7
    xor     7
    ret
    

