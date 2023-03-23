;
; Handle pragmas to disable the inclusion of various screen modes
;
; -pragma-define:CLIB_DISABLE_MODE0=1
; -pragma-define:CLIB_DISABLE_MODE1=1 (also disables mangled mode)
; -pragma-define:CLIB_DISABLE_MODE2=1
; -pragma-define:CLIB_DISABLE_MODE3=1


EXTERN l_ret
EXTERN __vdp_mode_noop_term

IF CLIB_DISABLE_MODE0
    PUBLIC __vdp_mode0
    PUBLIC __vdp_mode0_term

    defc __vdp_mode0 = l_ret
    defc __vdp_mode0_term = __vdp_mode_noop_term

    PUBLIC  __CLIB_DISABLE_MODE0
    defc    __CLIB_DISABLE_MODE0 = 1
ENDIF

IF CLIB_DISABLE_MODE1
    PUBLIC __vdp_mode1
    PUBLIC __vdp_mode1_term

    ;; Mode1 is disabled, so is mangled mode
    PUBLIC  vdp_set_mangled_mode
    PUBLIC  _vdp_set_mangled_mode
    PUBLIC  __vdp_mode1_2_term
    defc vdp_set_mangled_mode = l_ret
    defc _vdp_set_mangled_mode = vdp_set_mangled_mode
    defc __vdp_mode1_2_term = __vdp_mode_noop_term


    defc __vdp_mode1 = l_ret
    defc __vdp_mode1_term = __vdp_mode_noop_term

    PUBLIC  __CLIB_DISABLE_MODE1
    defc    __CLIB_DISABLE_MODE1 = 1
ENDIF

IF CLIB_DISABLE_MODE2
    PUBLIC __vdp_mode2
    PUBLIC __vdp_mode2_term

    defc __vdp_mode2 = l_ret
    defc __vdp_mode2_term = __vdp_mode_noop_term

    PUBLIC  __CLIB_DISABLE_MODE2
    defc    __CLIB_DISABLE_MODE2 = 1
ENDIF

IF CLIB_DISABLE_MODE3
    PUBLIC __vdp_mode3
    PUBLIC __vdp_mode3_term

    defc __vdp_mode3 = l_ret
    defc __vdp_mode3_term = __vdp_mode_noop_term

    PUBLIC  __CLIB_DISABLE_MODE3
    defc    __CLIB_DISABLE_MODE3 = 1
ENDIF




IF CLIB_DISABLE_MODE4
    ; MSX V9938 GRAPHICS III
    PUBLIC __vdp_mode4
    PUBLIC __vdp_mode4_term

    defc __vdp_mode4 = l_ret
    defc __vdp_mode4_term = __vdp_mode_noop_term

    PUBLIC  __CLIB_DISABLE_MODE4
    defc    __CLIB_DISABLE_MODE4 = 1
ENDIF

IF CLIB_DISABLE_MODE80
    ; MSX V99938 TEXT II
    PUBLIC __vdp_mode0_80col
    PUBLIC __vdp_mode0_80col_term

    defc __vdp_mode0_80col = l_ret
    defc __vdp_mode0_80col_term = __vdp_mode_noop_term

    PUBLIC  __CLIB_DISABLE_MODE4
    defc    __CLIB_DISABLE_MODE4 = 1
ENDIF
