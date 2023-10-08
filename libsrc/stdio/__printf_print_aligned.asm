    MODULE  __printf_print_aligned
    SECTION code_clib
    PUBLIC  __printf_print_aligned
    EXTERN  __printf_doprint
    EXTERN  l_ge

    EXTERN  __printf_get_width
    EXTERN  __printf_is_padding_zero
    EXTERN  __printf_check_pad_right

; Entry: bc = buffer to print
;        de = length of the buffer
__printf_print_aligned:
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_get_width
ELSE
    ld      l,(ix-6)        ;width
    ld      h,(ix-5)
ENDIF
    ld      a,h
    or      l
    jr      z,width_done
    push    hl
    push    bc
    call    l_ge             ;disturbs hl + bc
    pop     bc
    pop     hl
    jr      nc,adjust_width
    ld      hl,0
    jr      width_done
adjust_width:
    and     a
IF __CPU_INTEL__ | __CPU_GBZ80__
    ld      a,l
    sub     e
    ld      l,a
    ld      a,h
    sbc     d
    ld      h,a
width_done:
    call    __printf_check_pad_right
ELSE
    sbc     hl,de
width_done:
    bit     0,(ix-4)
ENDIF
    push    bc
    call    z,print_padding ; Doing rightaligh, pad it out
    pop     bc
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

    ; Now the right padding - hl is how many characters left to print
print_buffer_end:
	ld      c,' '		; We have to a trailing pad with ' '
print_padding_loop:
    ld      a,h
    or      l
    ret     z
    push    bc
    ld      a,c
    call    __printf_doprint
    pop     bc
    dec     hl
    jr      print_padding

print_padding:
    ld      c,' '
IF __CPU_INTEL__ | __CPU_GBZ80__
    call    __printf_is_padding_zero
ELSE
    bit     2,(ix-4)
ENDIF
    jr      z,print_padding_loop
    ld      c,'0'
    jr      print_padding_loop
