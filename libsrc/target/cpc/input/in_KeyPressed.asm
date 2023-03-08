; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
PUBLIC asm_in_KeyPressed_direct
EXTERN __cpc_scan_allrows
EXTERN __cpc_keystate

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
;              bit 7 of L set if SHIFT needs to be pressed
;              bit 6 of L set if CTRL needs to be pressed
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

in_KeyPressed:
_in_KeyPressed:
    push    hl
    call    __cpc_scan_allrows
    pop     de
asm_in_KeyPressed_direct:
    ld      a,e
    and     15
    ld      c,a
    ld      b,0
    ld      hl,__cpc_keystate
    add     hl,bc
    ld      a,(hl)
    cpl
    and     d
    jr      nz,keypressed

fail:
    ld      hl,0
    and     a
    ret

keypressed:
    ; Now we need to check ctrl + shift keys
    ; CTRL = row 2, bit 7
    ; SHIFT = row 2, bit 5
    xor      a
    bit      7,e    ;shift
    jr       z,noshift
    or       @00100000
noshift:
    bit      6,e
    jr       z,noctrl
    or       @10000000
noctrl:
    ld       d,a
    ld       a,(__cpc_keystate+2)
    cpl
    and      @10100000
    cp       d
    jr       nz,fail
    ld       hl,1
    scf
    ret


    
