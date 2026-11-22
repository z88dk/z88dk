; 
; Amstrad CPC joysticks
;
; 1 = Joystick 1
; 2 = Joystick 2
; 3 = QAOP-MN
; 4 = Cursors SPACE RET
; 5 = vi keys


    SECTION code_clib
    PUBLIC  joystick
    PUBLIC  _joystick
    EXTERN  __cpc_scan_allrows
    EXTERN  __cpc_keystate
    EXTERN  asm_in_KeyPressed_direct

joystick:
_joystick:
    ld      a,l
    push    af
    call    __cpc_scan_allrows
    pop     af
    add     a  ;*2
    ld      c,a
    add     a  ;*4
    add     c  ;*6
    add     a  ;*12
    ld      c,a
    ld      b,0
    ld      hl,__joykeys_table - 12
    add     hl,bc
    ; hl = keytable to read
    ld      b,6
    ld      c,0
loop:
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    push    hl
    push    bc
    call    asm_in_KeyPressed_direct
    pop     bc
    rl      c
    pop     hl
    djnz    loop
    ld      l,c
    ld      h,0
    ret


; joystick keys
    SECTION rodata_clib


__joykeys_table:
; joystick 1
    defw    $2009, $1009, $0109, $0209, $0409, $0809
; joystick 2
    defw    $2006, $1006, $0106, $0206, $0406, $0806
;nmqaop
    defw    $4005, $4004, $0808, $2008, $0404, $0803
; SP ENT UP DOWN LEFT RIGHT
    defw    $8005, $0402, $0100, $0400, $0101, $0200
;d s k j h l
    defw    $2007, $1007, $2004, $2005, $1005, $1004

