;       Small C+ Z88 Support Library
;
;       Convert signed long to int
;       NB. This routine will only work if long < +/-32767ish (obvious)


                XLIB    l_long2int_s


;This routine picks up the sign in d (MSB) sticks into the MSB of h
;Perhaps this routine could be inlined? Certainly short enough!

.l_long2int_s
        rl      h
        rl      d
        rr      h
        ret

