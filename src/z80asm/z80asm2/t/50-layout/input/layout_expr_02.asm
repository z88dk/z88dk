defb -129, -128, -127, -1, 0, 1, 127, 128, 255, 256
defw -32769, -32768, -32767, -1, 0, 1, 32767, 32768, 65535, 65536

if !__CPU_GBZ80__
ld a,(ix-129)
ld a,(ix-128)
ld a,(ix-1)
ld a,(ix+1)
ld a,(ix+127)
ld a,(ix+128)
ld a,(ix+255)
endif

if __CPU_GBZ80__
ldh a, (0xFF00)
ldh a, (0xFF01)
ldh a, (0xFFFF)
ldh a, (0x00)
ldh a, (0xFF)
ldh a, (0x100)
ldh a, (0xFEFF)
endif

defw_be -32769, -32768, -32767, -1, 0, 1, 32767, 32768, 65535, 65536
jr -129
jr 128

if __CPU_R4K__
jre -32769
jre 32768
endif

org 0x100
defb $FF

align 16, $AA
defb $FF

align 16
defb $FF

defs 16, $55
defs 16, "hello"
