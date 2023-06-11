;-------------------------------------------------------------------------
; Native terminal i/o functionality for micro8085_cilb (stdio interface)

        SECTION code_clib

        EXTERN  getk

        PUBLIC  fgetc_cons
        PUBLIC  _fgetc_cons

;-------------------------------------------------------------------------
; Function will stall until data is available to pull from buffer
fgetc_cons:
_fgetc_cons:
        call    getk            ;poll until rcvd char
        jp      z,fgetc_cons    ;z flag set by getk
        ret
