

	PUBLIC putsprite
	PUBLIC _putsprite
        EXTERN __generic_putsprite

	defc putsprite = __generic_putsprite
	defc _putsprite = putsprite
