; The first stage of a program linked at $0000 (CRT_MZ2500_IPL_DISABLED), in the page the IPL starts at $8000: it maps RAM pages 16 to 19 into windows 0 to 3
; (the program, then the first bank) and jumps to the program.  appmake (mz2500) finds <name>_BOOTSTRAP.bin and puts it at the start of that page, where the
; program's own code for the page (section BANK_12) leaves STUB_SPACE (32) bytes free.  The program's pages must be the ones appmake lists: LOW_PAGE (16) and the next.

    SECTION BOOTSTRAP

    PUBLIC  __mz2500_bootstrap_built
    defc    __mz2500_bootstrap_built = 1

    org     $8000

    di
    xor     a
    out     ($b4),a                     ; window 0
    ld      a,16                        ; the program's first page
    out     ($b5),a                     ; the window steps on after each write
    inc     a
    out     ($b5),a
    inc     a
    out     ($b5),a
    inc     a
    out     ($b5),a
    jp      $0000
