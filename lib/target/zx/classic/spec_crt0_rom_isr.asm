;
; ZX Spectrum startup code for z88dk
; ROM mode interrupt handler, part of spec_crt0.asm
; this file is linked in when the "-startup=2" parameter is used
;
; Stefano, 2019:  made it simpler, ROM specific functions for keyboard scanning are provided
;
; $Id: spec_crt0_rom_isr.asm $
;


; This block starts at location $0038, (56 decimal).

    push   af
    push   hl
    
    ld     hl,(_FRAMES)      ; frames
    inc    hl
    ld     (_FRAMES),hl
    ld     a,h
    or     l
    jp     nz,interrupt_end
    ld     hl,_FRAMES+2
    inc    (hl)
    
interrupt_end:
    pop    hl	; End of interrrupt
    pop    af
    ei
    ret

