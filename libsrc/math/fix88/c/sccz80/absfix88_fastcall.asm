   SECTION code_clib


    PUBLIC  absfix88_fastcall
    PUBLIC  _absfix88_fastcall

    EXTERN  asm_abs

    defc    absfix88_fastcall = asm_abs
    defc    _absfix88_fastcall = asm_abs