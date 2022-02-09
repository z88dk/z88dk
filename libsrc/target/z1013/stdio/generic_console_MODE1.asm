

    PUBLIC  cls_MODE1
    PUBLIC  printc_MODE1
    PUBLIC  vpeek_MODE1
    PUBLIC  scrollup_MODE1

    EXTERN  __krt_cls
    EXTERN  __krt_printc
    EXTERN  __krt_vpeek
    EXTERN  __krt_scrollup

    defc    cls_MODE1 = __krt_cls
    defc    printc_MODE1 = __krt_printc
    defc    vpeek_MODE1 = __krt_vpeek
    defc    scrollup_MODE1 = __krt_scrollup
