#ifndef JOY_H_
#define JOY_H_

#include "types.h"

#define PORT_A	(PORT_A_KEY_UP | PORT_A_KEY_DOWN | PORT_A_KEY_LEFT | PORT_A_KEY_RIGHT| PORT_A_KEY_1 | PORT_A_KEY_2 )
#define PORT_B	(PORT_B_KEY_UP | PORT_B_KEY_DOWN | PORT_B_KEY_LEFT | PORT_B_KEY_RIGHT| PORT_B_KEY_1 | PORT_B_KEY_2 )

#define	JOY_1	0
#define	JOY_2	1


typedef void _inputPressedCallback(unsigned char joy, unsigned int pressed, unsigned int state);
typedef void _inputReleasedCallback(unsigned char joy, unsigned int released, unsigned int state);

void JOY_setPressedCallback(_inputPressedCallback *CB) __z88dk_fastcall;
void JOY_setReleasedCallback(_inputReleasedCallback *CB) __z88dk_fastcall;

void JOY_init();
void JOY_update();


#endif /* JOY_H_ */
