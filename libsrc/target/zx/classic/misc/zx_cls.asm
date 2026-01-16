

SECTION code_clib

PUBLIC zx_cls_attr
PUBLIC _zx_cls_attr
PUBLIC zx_cls_attr_fastcall
PUBLIC _zx_cls_attr_fastcall
PUBLIC zx_cls
PUBLIC _zx_cls

EXTERN __zx_console_attr
EXTERN generic_console_cls

defc zx_cls = generic_console_cls
defc _zx_cls = zx_cls


; zx_cls(int attr)
;
; Clears the screen and sets the default text/graphics attribute

zx_cls_attr:
_zx_cls_attr:
   ld       hl,2
   add      hl,sp
   ld       l,(hl)

zx_cls_attr_fastcall:
_zx_cls_attr_fastcall:
    ex      de,hl
    ld      hl,__zx_console_attr
    ld      (hl),e
    jp      generic_console_cls	;preserves de,bc
