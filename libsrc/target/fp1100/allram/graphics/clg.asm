; Skeleton for the all-RAM overlay (doc/target/fp1100/subcpu-plan.md): replaces the ROM-based stock module of the same name.

    MODULE  fp1100_allram_clg
    SECTION code_clib
    PUBLIC  clg
    PUBLIC  _clg
    EXTERN  generic_console_cls

    defc    clg=generic_console_cls
    defc    _clg=generic_console_cls
