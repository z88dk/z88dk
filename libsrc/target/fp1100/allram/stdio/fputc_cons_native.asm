; Skeleton for the all-RAM overlay (doc/target/fp1100/subcpu-plan.md): replaces the ROM-based stock module of the same name.

    MODULE  fp1100_allram_fputc_cons_native
    SECTION code_clib
    PUBLIC  fputc_cons_native
    PUBLIC  _fputc_cons_native

fputc_cons_native:
_fputc_cons_native:
    ret
