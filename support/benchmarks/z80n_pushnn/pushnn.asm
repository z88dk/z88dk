; z80n PUSH NNNN big-endian storage probes.
; ED 8A HI LO pushes the operand bytes in fetch order: HI ends at the final SP.
SECTION code_user
PUBLIC _pn_1, _pn_1234, _pn_0100, _pn_pair

_pn_1:
    push 1          ; ED 8A 00 01
    pop hl
    ret

_pn_1234:
    push 0x1234     ; ED 8A 12 34
    pop hl
    ret

_pn_0100:
    push 0x0100     ; ED 8A 01 00
    pop hl
    ret

_pn_pair:
    push 10000      ; ED 8A 27 10
    push 1          ; ED 8A 00 01
    pop hl          ; top of stack = the pushed 1, byte-swapped
    ret
