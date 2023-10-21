;
;      Tape save routine
;
;      Stefano, 2022
;
;      int  bit_save_msx(char *name, size_t loadstart, void *start, void *exec, size_t len);
;

        SECTION code_clib

        PUBLIC  bit_save_msx
        PUBLIC  _bit_save_msx

        EXTERN  asm_bit_save_msx


bit_save_msx:
_bit_save_msx:

  IF    __CPU_GBZ80__||__CPU_INTEL__
        ret
  ELSE

        POP     AF                      ; ret_addr
        POP     DE                      ; len
        POP     BC                      ; exec
        POP     HL                      ; start
        EXX
        POP     DE                      ; loadstart
        POP     HL                      ; name

        PUSH    HL
        PUSH    DE
        EXX
        PUSH    HL
        PUSH    BC
        PUSH    DE
        PUSH    AF

        EXX
        jp      asm_bit_save_msx

  ENDIF
