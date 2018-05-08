;------------------------------------------------------------------------------  
;       Initialises the APU buffers
;
;       void apu_reset( void );

    SECTION code_driver

    PUBLIC _apu_reset

    EXTERN asm_am9511a_reset

    defc _apu_reset   =  asm_am9511a_reset

