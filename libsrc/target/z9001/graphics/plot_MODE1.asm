    PUBLIC  plot_MODE1

    EXTERN  __krt_plot
    EXTERN  __z9001_attr

plot_MODE1:
    call    __krt_plot
    dec     h
    dec     h
    dec     h
    dec     h
    ld      a,(__z9001_attr)
    ld      (hl),a
    ret