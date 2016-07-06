

        MODULE  __scanf_handle_c
        SECTION code_clib
        PUBLIC  __scanf_handle_c

	EXTERN  __scanf_common_start
        EXTERN  __scanf_nextarg
        EXTERN  scanf_exit
        EXTERN  __scanf_ungetchar
        EXTERN  __scanf_getchar
        EXTERN  scanf_loop

__scanf_handle_c:
        ld      b,1             ;width
        bit     2,(ix-3)        ;is there a width specified?
        jr      z,c_fmt_get_buf
        ld      b,(ix-4)        ;width
c_fmt_get_buf:
        ; TODO: Handling of *, bit 3
        call    __scanf_nextarg ;de = destination
c_fmt_loop:
        call    __scanf_getchar
        jp      c,scanf_exit    ;error occurred
        ld      (de),a
        inc     de
        djnz    c_fmt_loop
        inc     (ix-1)          ;increment number of conversions done
        jp      scanf_loop
