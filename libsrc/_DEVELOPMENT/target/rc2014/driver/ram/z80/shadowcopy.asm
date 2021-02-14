
INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC asm_shadowcopy_begin
PUBLIC asm_shadowcopy_end

PUBLIC asm_shadowread
PUBLIC asm_shadowwrite

;   @feilipu February 2021
;
;   The RAM bank is toggled by outputting 1/0 to 0x0030
;
;   On entry: Interrupts disabled unless you know better
;             A  = Source RAM bank (0 / 1)
;             HL = Source start address (in RAM)
;             DE = Destination start address (in RAM)
;             BC = Number of bytes to copy
;
;   On exit:  AF BC DE HL not specified
;             IX IY I AF' BC' DE' HL' preserved
;             carry reset

.asm_shadowcopy_begin

.asm_shadowread
    out (__IO_RAM_TOGGLE),a ; now in other bank
    rra                     ; move current bank to carry

.asm_shadowwrite
    ld a,c                  ; swap BC to use cheap djnz inner loop
    dec bc
    inc b
    ld c,b
    ld b,a

.copyloop
    ld a,(hl)               ; get the byte
    inc hl

    ccf                     ; toggle bank
    rla                     ; carry to bit 0
    out (__IO_RAM_TOGGLE),a ; now in other bank
    rra                     ; recover carry and byte

    ld (de),a               ; store the byte
    inc de

    ccf                     ; toggle bank
    rla                     ; carry to bit 0
    out (__IO_RAM_TOGGLE),a ; now in other bank
    rra                     ; recover carry

    djnz copyloop           ; decrement LSB (without affecting carry)

    dec c                   ; decrement MSB (without affecting carry)
    jr NZ,copyloop

    xor a                   ; get to front bank
    out (__IO_RAM_TOGGLE),a ; now in front bank
    ret

.asm_shadowcopy_end
