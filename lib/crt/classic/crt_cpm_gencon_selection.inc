;
; Allow selection of the library functions at linktime
;
; - generic_console driver redirection in CP/M targets
;
; Included by crt0 files
;



;--------
; -pragma-need=vt52
;--------

IF NEED_vt52
    PUBLIC  CLIB_GENCON_CAPS
    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_ioctl
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    EXTERN  CLIB_GENCON_CAPS_vt52
    EXTERN  generic_console_cls_vt52
    EXTERN  generic_console_vpeek_vt52
    EXTERN  generic_console_scrollup_vt52
    EXTERN  generic_console_printc_vt52
    EXTERN  generic_console_ioctl_vt52
    EXTERN  generic_console_set_ink_vt52
    EXTERN  generic_console_set_paper_vt52
    EXTERN  generic_console_set_attribute_vt52

    defc  CLIB_GENCON_CAPS = CLIB_GENCON_CAPS_vt52
    defc  generic_console_cls = generic_console_cls_vt52
    defc  generic_console_vpeek = generic_console_vpeek_vt52
    defc  generic_console_scrollup = generic_console_scrollup_vt52
    defc  generic_console_printc = generic_console_printc_vt52
    defc  generic_console_ioctl = generic_console_ioctl_vt52
    defc  generic_console_set_ink = generic_console_set_ink_vt52
    defc  generic_console_set_paper = generic_console_set_paper_vt52
    defc  generic_console_set_attribute = generic_console_set_attribute_vt52
ENDIF
	


;--------
; -pragma-need=h19
;--------

IF NEED_h19
    PUBLIC  CLIB_GENCON_CAPS
    PUBLIC  generic_console_cls
    PUBLIC  generic_console_vpeek
    PUBLIC  generic_console_scrollup
    PUBLIC  generic_console_printc
    PUBLIC  generic_console_ioctl
    PUBLIC  generic_console_set_ink
    PUBLIC  generic_console_set_paper
    PUBLIC  generic_console_set_attribute

    PUBLIC  generic_console_plotc
    PUBLIC  generic_console_pointxy

    EXTERN  CLIB_GENCON_CAPS_h19
    EXTERN  generic_console_cls_h19
    EXTERN  generic_console_vpeek_h19
    EXTERN  generic_console_scrollup_h19
    EXTERN  generic_console_printc_h19
    EXTERN  generic_console_ioctl_h19
    EXTERN  generic_console_set_ink_h19
    EXTERN  generic_console_set_paper_h19
    EXTERN  generic_console_set_attribute_h19
    EXTERN  generic_console_plotc_h19
    EXTERN  generic_console_pointxy_h19

    defc  CLIB_GENCON_CAPS = CLIB_GENCON_CAPS_h19
    defc  generic_console_cls = generic_console_cls_h19
    defc  generic_console_vpeek = generic_console_vpeek_h19
    defc  generic_console_scrollup = generic_console_scrollup_h19
    defc  generic_console_printc = generic_console_printc_h19
    defc  generic_console_ioctl = generic_console_ioctl_h19
    defc  generic_console_set_ink = generic_console_set_ink_h19
    defc  generic_console_set_paper = generic_console_set_paper_h19
    defc  generic_console_set_attribute = generic_console_set_attribute_h19

    defc  generic_console_plotc = generic_console_plotc_h19
    defc  generic_console_pointxy = generic_console_pointxy_h19
ENDIF

