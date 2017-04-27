#include <arch/sms/SMSlib.h>
#include "joy.h"

static _inputPressedCallback *pressedCB;
static _inputReleasedCallback *releasedCB;



void JOY_setPressedCallback(_inputPressedCallback *CB) __z88dk_fastcall
{
	pressedCB = CB;
}

void JOY_setReleasedCallback(_inputReleasedCallback *CB) __z88dk_fastcall
{
	releasedCB = CB;
}

void JOY_update()
{
	unsigned int keys;
	unsigned int keysState = SMS_getKeysStatus();
	
	keys = SMS_getKeysPressed();
	if ((keys & PORT_A) && (pressedCB!=NULL))	pressedCB(JOY_1, keys, keysState);
#ifndef TARGET_GG	
	if ((keys & PORT_B) && (pressedCB!=NULL))	pressedCB(JOY_2, keys, keysState);
#endif

	keys = SMS_getKeysReleased();
	if ((keys & PORT_A) && (releasedCB!=NULL))	releasedCB(JOY_1, keys, keysState);
#ifndef TARGET_GG	
	if ((keys & PORT_B) && (releasedCB!=NULL))	releasedCB(JOY_2, keys, keysState);	
#endif
}

void JOY_init()
{
	releasedCB = NULL;
	pressedCB = NULL;
}
