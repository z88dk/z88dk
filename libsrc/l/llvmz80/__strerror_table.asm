; __strerror_table.asm -- minimal errno string table for the classic CP/M
; build under ravn/llvm-z80 clang.
;
; asm_strerror searches a table at __rodata_error_strings_head. The newlib CRT
; defines that section-start symbol; the classic CRT does not, so strerror()
; fails to link. This TU provides the symbol + a table for classic errno.h
; (EACCES..EWOULDBLOCK, ~140 B, demand-loaded via libsrc/l/llvmz80.lst).
;
; Table format (per asm_strerror): [errnum][name][NUL]... then [0x00] sentinel
; (errnum 0 == EOK handled before the search).
;
; Values from classic include/errno.h (NOT newlib's, which differ):
;   EACCES=1 EBADF=2 EBDFD=3 EDOM=4 EFBIG=5 EINVAL=6 EMFILE=7 ENFILE=8
;   ENOLCK=9 ENOMEM=10 ENOTSUP=11 EOVERFLOW=12 ERANGE=13 ESTAT=14
;   EAGAIN=15 EWOULDBLOCK=16  (EIO absent; ERANGE mistyped as ANGE in errno.h)
;
; Lives in code_l_clang, not rodata_error_strings, so it never clashes with the
; newlib link's auto-generated section-start symbol; asm_strerror only needs a
; valid pointer.
SECTION code_l_clang

PUBLIC __rodata_error_strings_head

__rodata_error_strings_head:

    defb 1  : defm "EACCES"     : defb 0
    defb 2  : defm "EBADF"      : defb 0
    defb 3  : defm "EBDFD"      : defb 0
    defb 4  : defm "EDOM"       : defb 0
    defb 5  : defm "EFBIG"      : defb 0
    defb 6  : defm "EINVAL"     : defb 0
    defb 7  : defm "EMFILE"     : defb 0
    defb 8  : defm "ENFILE"     : defb 0
    defb 9  : defm "ENOLCK"     : defb 0
    defb 10 : defm "ENOMEM"     : defb 0
    defb 11 : defm "ENOTSUP"    : defb 0
    defb 12 : defm "EOVERFLOW"  : defb 0
    defb 13 : defm "ERANGE"     : defb 0
    defb 14 : defm "ESTAT"      : defb 0
    defb 15 : defm "EAGAIN"     : defb 0
    defb 16 : defm "EWOULDBLOCK": defb 0
    defb 0  ; sentinel
