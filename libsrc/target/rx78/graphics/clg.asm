;
; Switch to graphics (hires) mode and clear screen
;

    SECTION     code_clib
      PUBLIC    clg
      PUBLIC    _clg

    EXTERN    generic_console_cls

      INCLUDE "ioctl.def"

.clg
._clg
    call    generic_console_cls
      ret
