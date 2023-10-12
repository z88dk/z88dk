

        PUBLIC  putsprite
        PUBLIC  _putsprite
        PUBLIC  ___putsprite
        EXTERN  __generic_putsprite

        defc    putsprite=__generic_putsprite
        defc    _putsprite=putsprite
        defc    ___putsprite=putsprite
