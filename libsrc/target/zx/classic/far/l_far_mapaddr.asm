;
; Map a banked address to a far pointer
;



SECTION code_l_sccz80_far
PUBLIC  l_far_mapaddr


; ZX Bank mapping is a bit funky, so we have to use a table to 
; do the mapping
;
; Entry: ehl = banked address
; Exit:  ehl = far address
l_far_mapaddr:
    push    hl
    ld      a,e
    add     a
    ld      e,a
    ld      d,0
    ld      hl,__zx_bank_to_far
    add     hl,de
    ld      d,(hl)	;High 2 bits of address
    inc     hl
    ld      e,(hl)	;Segment number
    pop     hl
    ld      a,h
    and     @00111111
    or      d
    ld      h,a
    ld      d,0
    ret


; Support up to 128k of heap, but...
; last 64k conflict with other things
; Last 32k really conflict
;    defb    1,3,4,6,0,7,2,5
__zx_bank_to_far:
    ; Bank 0
    defb    %00000000   ;High word bit
    defb    2           ;Far segment
    ; Bank 1
    defb    %00000000   ;High word bit
    defb    1           ;Far segment
    ; Bank 2
    defb    %10000000   ;High word bit
    defb    2           ;Far segment
    ; Bank 3
    defb    %01000000   ;High word bit
    defb    1           ;Far segment
    ; Bank 3
    defb    %01000000   ;High word bit
    defb    1           ;Far segment
    ; Bank 4
    defb    %10000000   ;High word bit
    defb    1           ;Far segment
    ; Bank 5
    defb    %11000000   ;High word bit
    defb    2           ;Far segment
    ; Bank 6
    defb    %11000000   ;High word bit
    defb    1           ;Far segment
    ; Bank 7
    defb    %01000000   ;High word bit
    defb    2           ;Far segment

