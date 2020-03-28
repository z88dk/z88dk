;
;

        SECTION   code_clib
        PUBLIC    clg
        PUBLIC    _clg
        EXTERN  generic_console_cls

        defc clg = generic_console_cls
        defc _clg = generic_console_cls

