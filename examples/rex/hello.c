/*
 *
 * Hello World for REX 6000
 *
 * Written by Damjan Marion <dmarion@iskon.hr>
 *
 */

#include <rex/rex.h>

int main()
{
	REXMSG msg;
	int flag=1;

	RexEventClear();
	RexClearScreen();
	RexPrintf(90,20,16,"Hello World");
	RexDialogTextButton(90, 80, 60, 20, 61, "Exit");

	/*Wait for event*/

	while (flag) {
	  RexEventMessageGet(&msg);
	  switch(msg.message) {
	    case MSG_REX_CLOSE: 
	    case MSG_REX_COMMAND: 
	    case MSG_REX_KEY_DOWN:
		flag=0;
	        RexBeepOn(2);
		break;
	  }
	}
}
