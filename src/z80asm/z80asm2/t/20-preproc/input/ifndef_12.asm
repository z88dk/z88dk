#define X 1
Y EQU 2
Z = 3

#ifndef not_defined_1
	ld a, 1
#else
	not reached
#endif

#ifndef not_defined_2
	ld a, 2
#else 
	not reached
#endif

#ifndef X
	not reached
#elseifndef Y
	not reached
#else
	ld a, 3
#endif

#ifndef X
	not reached
#elifndef Y
	not reached
#else
	ld a, 4
#endif

#ifndef not_defined_1
	#ifndef not_defined_2
		#ifndef not_defined_3
			ld a, 5
		#else
			not reached
		#endif
	#else
		not reached
	#endif
#else
	not reached
#endif
