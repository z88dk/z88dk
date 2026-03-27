IF FORts2068|FORzxn

SECTION code_graphics

PUBLIC stencil_render
PUBLIC _stencil_render
EXTERN __generic_stencil_render
EXTERN __pixladdr_stencil_render

EXTERN __zx_screenmode


  IF FORts2068
    defc stencil_render= __pixladdr_stencil_render
    defc _stencil_render= stencil_render
  ELSE

;; On ZXN we have 1bpp screens and tilemap/layer2 screens, so we need to check the screen mode and dispatch to the appropriate routine
stencil_render:
_stencil_render:
    ld      a, (__zx_screenmode)
    cp      64
    jp      c, __pixladdr_stencil_render
    jp      __generic_stencil_render
  ENDIF

ENDIF