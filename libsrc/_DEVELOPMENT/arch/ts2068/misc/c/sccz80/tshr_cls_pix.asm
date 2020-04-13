; void tshr_cls_pix(uchar pix)

SECTION code_clib
SECTION code_arch

PUBLIC tshr_cls_pix

EXTERN asm_tshr_cls_pix

defc tshr_cls_pix = asm_tshr_cls_pix

; SDCC bridge for Classic
IF __CLASSIC
PUBLIC _tshr_cls_pix
defc _tshr_cls_pix = tshr_cls_pix
ENDIF

