
INCLUDE "config_private.inc"

SECTION smc_driver

PUBLIC asm_shadowcopy
PUBLIC asm_shadowcopy_end

;   @feilipu February 2021
;
;   The RAM bank is toggled by outputting 0/1 to 0x0030
;
;   This code is located in the DATA section and, for ROM builds,
;   is copied to both main and shadow RAM banks during initialisation.
;
;   If desired, this code can be relocated wherever it suits the user.
;
;   On entry: Interrupts disabled unless you know better
;             HL = Source start address (in RAM)
;             DE = Destination start address (in RAM)
;             BC = Number of bytes to copy
;             carry = Source RAM bank (set = shadow bank)
;
;   On exit:  AF BC DE HL not specified
;             IX IY AF' BC' DE' HL' preserved
;             carry reset

.asm_shadowcopy
    rla                     ; get source bank number into A
    out (__IO_RAM_TOGGLE),a ; now in initial bank
    rra                     ; move current bank number into carry

    ld a,c                  ; swap BC to use cheap djnz for LSB loop
    dec bc
    inc b
    ld c,b
    ld b,a

.copyloop
    ld a,(hl)               ; get the byte
    inc hl

    ccf                     ; toggle bank number
    rla                     ; bank number in carry into bit 0
    out (__IO_RAM_TOGGLE),a ; now in other bank
    rra                     ; recover byte and save bank number in carry

    ld (de),a               ; store the byte
    inc de

    ccf                     ; toggle bank number
    rla                     ; bank number in carry to bit 0
    out (__IO_RAM_TOGGLE),a ; now in other bank
    rra                     ; save bank number in carry

    djnz copyloop           ; decrement LSB

    dec c                   ; decrement MSB
    jr NZ,copyloop

    xor a                   ; get front bank
    out (__IO_RAM_TOGGLE),a ; now in front bank
    ret

.asm_shadowcopy_end
