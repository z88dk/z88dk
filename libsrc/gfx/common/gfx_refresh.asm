

        SECTION code_graphics

        PUBLIC  gfx_refresh
        PUBLIC  _gfx_refresh
        PUBLIC  ___gfx_refresh
        EXTERN  l_ret

        defc    gfx_refresh=l_ret
        defc    _gfx_refresh=gfx_refresh
        defc    ___gfx_refresh=gfx_refresh
