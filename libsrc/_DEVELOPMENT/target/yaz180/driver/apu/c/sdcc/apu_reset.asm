;------------------------------------------------------------------------------  
;       Initialises the APU buffers
;
;       HL = address of the jump table nmi address
;
;       void apu_reset( void * nmi_address );

    SECTION code_driver

    PUBLIC _apu_reset

    Extern asm_am9511a_reset

_apu_reset:
    pop af
    pop hl
    push hl
    push af

    jp asm_am9511a_reset

