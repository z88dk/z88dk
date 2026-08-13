; Phase A smoke harness for ast-codegen2.
;
; Layout:
;   0x0000 jp _start           (3 bytes)
;   0x0003 padding to 0x06     (3 bytes)
;   0x0006 _exit entry         (-end 6 stops the emulator here; HL holds main's return)
;   0x000a _start (call _main; jp _exit)
;   0x0010 _main starts here   (linker places it after the harness)

    org 0
    jp _start
    defs 6 - $
_exit:
    ld a, 0
    defb $ed, $fe       ; (no-op on Z80, ticks doesn't recognize it as exit)
_start:
    call _main
    jp _exit

    EXTERN _main
