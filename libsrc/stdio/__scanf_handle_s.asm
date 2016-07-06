

        MODULE  __scanf_handle_s
        SECTION code_clib
        PUBLIC  __scanf_handle_s

        EXTERN  __scanf_common_start
        EXTERN  __scanf_nextarg
	EXTERN  __scanf_consume_whitespace
        EXTERN  scanf_exit
        EXTERN  __scanf_ungetchar
        EXTERN  __scanf_getchar
        EXTERN  scanf_loop

	EXTERN  asm_isspace

__scanf_handle_s:
        bit     3,(ix-3)
        call    z,__scanf_nextarg               ;de=destination
        ld      b,(ix-4)                ;b=width
scanf_fmt_s_width_specified:
        call    __scanf_consume_whitespace
        jp      c,scanf_exit
        call    __scanf_getchar
        jr      nc,scanf_fmt_s_join
        jp      scanf_exit
scanf_fmt_s_loop:
        call    __scanf_getchar
        jr      c,scanf_fmt_s_done
        call    asm_isspace
        jr      z,scanf_fmt_s_success
scanf_fmt_s_join:
        bit     3,(ix-3)        ;we're not setting
        jr      nz,scanf_fmt_s_suppress
        ld      (de),a
        inc     de
scanf_fmt_s_suppress:
        bit     2,(ix-3)        ;if no width specifier just loop
        jr      z,scanf_fmt_s_loop
        djnz    scanf_fmt_s_loop
scanf_fmt_s_done:
        xor     a
        bit     3,(ix-1)        ;suppress setting
        jp      nz,scanf_loop
        ld      (de),a          ;terminating \0
        inc     (ix-1)          ;increase number of conversions done
        jp      scanf_loop
scanf_fmt_s_success:
        call    __scanf_ungetchar
        jr      scanf_fmt_s_done
