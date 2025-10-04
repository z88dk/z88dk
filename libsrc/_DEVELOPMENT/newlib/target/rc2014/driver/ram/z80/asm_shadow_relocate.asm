
INCLUDE "config_private.inc"

SECTION smc_driver

EXTERN asm_shadow_copy
EXTERN asm_shadow_copy_end

PUBLIC asm_shadow_relocate

;   @feilipu November 2021
;
;   The RAM bank is toggled by outputting 0/1 to 0x0030
;
;   asm_shadow_copy is located in the DATA section and, for ROM builds,
;   is copied to both main and shadow RAM banks during initialisation.
;
;   The current location of asm_shadow_copy is maintained at base 0x0058.
;   The C interfaces use this address to find the location this code.
;
;   If desired, this code can be relocated wherever it suits the user.
;   This can be done with the C shadow_relocate(void * addr) function,
;   which will also update the base address.
;
;   On entry: Interrupts disabled unless you know better
;             HL = New address (in RAM)
;
;   On exit:  AF BC DE HL not specified
;             IX IY AF' BC' DE' HL' preserved

.asm_shadow_relocate
    ex de,hl                ; destination to de
    push de                 ; save a copy of destination

    ld hl,shadow_relocate_continue  ; save our return address after copy
    push hl

    ld hl,(__IO_RAM_SHADOW_BASE)    ; location of stub
    push hl                 ; save for jp (__IO_RAM_SHADOW_BASE)

    ld bc,asm_shadow_copy_end-asm_shadow_copy   ; size of stub

    or a                    ; write to shadow RAM
    ret                     ; copy it by jp (__IO_RAM_SHADOW_BASE)

.shadow_relocate_continue
    pop de                  ; recover destination

    ld hl,(__IO_RAM_SHADOW_BASE)    ; location of stub
    ld (__IO_RAM_SHADOW_BASE),de    ; write new location to base
    
    ld bc,asm_shadow_copy_end-asm_shadow_copy   ; size of stub

    ldir                    ; copy it

    ret
