; Paging for address spaces for the MSX

SECTION code_user

PUBLIC _setb1, _setb4
EXTERN __msx_bank_mappings

EXTERN PUT_P2


_setb4:
    ld    c,4
    jr    page

_setb1:
    ld    c,1
page:
    push  hl
    ld    hl,__msx_bank_mappings
    ld    b,0
    add   hl,bc
    ld    a,(hl)
    call  PUT_P2
    pop   hl
    ret
