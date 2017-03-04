
	MODULE	__printf_print_aligned
	SECTION	code_clib
	PUBLIC	__printf_print_aligned
	EXTERN	__printf_doprint
	EXTERN	l_ge

; Entry: bc = buffer to print
;        de = length of the buffer
__printf_print_aligned:
        ld      l,(ix-6)        ;width
        ld      h,(ix-5)
        ld      a,h
        or      l
        jr      z,width_done
        push    hl
        push    bc
        call    l_ge             ;disturbs hl
        pop     bc
        pop     hl
        jr      nc,adjust_width
        ld      hl,0
        jr      width_done
adjust_width:
        and     a
        sbc     hl,de
width_done:
        bit     0,(ix-4)
        call    z,print_padding ; Doing rightaligh, pad it out
print_buffer:
        ld      a,d
        or      e
        jr      z,buffer_done
        ld      a,(bc)
;       and     a
;       jr      z,print_buffer_end
        call    __printf_doprint
        inc     bc
        dec     de
        jr      print_buffer
buffer_done:

        ; Now the right padding - hl is what we've got to print
print_buffer_end:
        res     2,(ix-4)        ; We can't do a trailing pad with 0!
print_padding:
        ld      a,h
        or      l
        ret     z
        ld      a,' '
        bit     2,(ix-4)
        jr      z,pad_is_space
        ld      a,'0'
pad_is_space:
        call    __printf_doprint
        dec     hl
        jr      print_padding
