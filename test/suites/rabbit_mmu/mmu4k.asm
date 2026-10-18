    org 0
    ld sp,0x3000
    ld a,0xc0
    ioi ld (0x420),a       ; EDMR: R4K instruction set
    ld hl,0xfabc
    ld lxpc,hl             ; 12 bit: 0x0abc
    ld hl,0
    ld hl,lxpc
    ld (0x0100),hl         ; 0x0abc
    ld a,0x5a
    ld (0xe123),a          ; physical 0xabc000 + 0xe123 = 0xaca123
    ldf a,(0xaca123)
    ld (0x0102),a
    ld hl,0x0def
    ld lxpc,hl
    llcall 0x0123,target   ; push lxpc 0x0def, switch to 0x0123
    ld hl,lxpc
    ld (0x0104),hl         ; restored 0x0def
    ld a,b
    ld (0x0106),a
    ld hl,callee
    ld jk,0x0457
    llcall (jkhl)
after:
    ld hl,lxpc
    ld (0x0108),hl         ; llret restored 0x0def
    lljp 0x0777,tail
    jr $
target:
    ld hl,lxpc
    ld (0x010a),hl         ; 0x0123 inside the call
    ld b,0x77
    llret
callee:
    ld hl,lxpc
    ld (0x010c),hl         ; 0x0457
    llret
tail:
    ld hl,lxpc
    ld (0x010e),hl         ; 0x0777
done:
    nop
