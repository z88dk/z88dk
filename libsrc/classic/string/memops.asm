; operations for memopi() and memopd()
; 06.2007 aralbrec

    SECTION code_clib

    PUBLIC  memops
    PUBLIC  _memops

; Every entry is padded to 4 bytes: the Rabbit 4000/6000 encode (hl) ALU ops
; as 2-byte 7F-prefixed opcodes, so the entries are not a fixed 2 bytes.
; memopi/memopd index this table as memops + 4 * op.

memops:
_memops:
opload:

    nop
    ret
    defs    opload + 4 - $

opor:

    or      (hl)
    ret
    defs    opor + 4 - $

opxor:

    xor     (hl)
    ret
    defs    opxor + 4 - $

opand:

    and     (hl)
    ret
    defs    opand + 4 - $

opadd:

    add     a, (hl)
    ret
    defs    opadd + 4 - $

opadc:

    adc     a, (hl)
    ret
    defs    opadc + 4 - $

opsub:

    sub     (hl)
    ret
    defs    opsub + 4 - $

opsbc:

    sbc     a, (hl)
    ret
    defs    opsbc + 4 - $

oprls:

    rla
    ret
    defs    oprls + 4 - $

oprrs:

    rra
    ret
    defs    oprrs + 4 - $
