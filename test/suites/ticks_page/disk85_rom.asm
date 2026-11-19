; ROM image for the 8085 disk harness.
; Byte 0 of this file is ROM address 0. Execution starts there.
; The jump to the runner is in this image. ticks does not place the file.

    org 0

    jp $8000
    defs $7131 - $
    defm "BDOS_DISK_OK"
    defb 0
    ASSERT $ == $713E
    defs $7628 - $
    defb $D1
    ASSERT $ == $7629
    defs $7893 - $
    defb $C3, $11
    ASSERT $ == $7895
