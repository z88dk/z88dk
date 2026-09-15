; z80n PUSH NNNN storage-order probe.
; For each case: pushes an immediate, snapshots the two bytes at the final SP
; (D = byte at SP, E = byte at SP+1), then pops and returns:
;   HL = popped 16-bit value, DE = raw stack bytes (D=E0, E=E1).
SECTION code_user
PUBLIC _probe_1234, _probe_0100, _probe_pair

sptmp:   defw 0

_probe_1234:
    ld (sptmp),sp
    push 0x1234         ; ED 8A 12 34 (assembler encodes HI LO)
    jp _snap

_probe_0100:
    ld (sptmp),sp
    push 0x0100         ; ED 8A 01 00
    jp _snap

_probe_pair:
    ld (sptmp),sp
    push 10000          ; ED 8A 27 10
    push 1              ; ED 8A 00 01
_snap:
    ld hl,(sptmp)
    dec hl
    dec hl              ; HL = final SP
    ld d,(hl)           ; D = byte at final SP
    inc hl
    ld e,(hl)           ; E = byte at SP+1
    pop hl              ; popped word
    ret
