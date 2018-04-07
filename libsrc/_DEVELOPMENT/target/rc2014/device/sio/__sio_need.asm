
    ; Generate references to any portions of SIO
    ; code that must be part of every compile that
    ; uses the SIO

    PUBLIC _sio_need

    EXTERN _sio_init

    defc _sio_need = _sio_init

    ; The SIO must be initialized before main is called

    SECTION code_crt_init
    call _sio_init

