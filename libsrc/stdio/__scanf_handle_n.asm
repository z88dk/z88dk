
        MODULE  __scanf_handle_n
        SECTION code_clib
        PUBLIC  __scanf_handle_n

        EXTERN  __scanf_nextarg
        EXTERN  scanf_loop


__scanf_handle_n:
        bit     3,(ix-3)                ;suppressed?
        jp      nz,scanf_loop
        call    __scanf_nextarg
        ld      a,(ix-6)
        ld      (de),a
        inc     de
        ld      a,(ix-5)
        ld      (de),a
        bit     1,(ix-3)
        jr      z,scanf_handle_n_exit
	xor	a
	inc	de
	ld	(de),a
	inc	de
	ld	(de),a
scanf_handle_n_exit:
        jp      scanf_loop
