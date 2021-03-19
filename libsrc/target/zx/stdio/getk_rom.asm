; getk() for use in ROMS, historical name

    SECTION code_clib
    PUBLIC  getk
    PUBLIC  _getk

    EXTERN  getk_inkey

    defc getk = getk_inkey
    defc _getk = getk
