/*
 *
 * Hello World for DS 6000
 *
 * Written by Damjan Marion <dmarion@iskon.hr>
 *
 */

#include <rex/rex.h>

int main()
{
	MSG msg;
	int flag=1;

	DsEventClear();
	DsClearScreen();
	DsPrintf(90,20,16,"Hello World");
	DsDialogTextButton(90, 80, 60, 20, 61, "Exit");

	/*Wait for event*/

	while (flag) {
	  DsEventMessageGet(&msg);
	  switch(msg.message) {
	    case MSG_DS_CLOSE: 
	    case MSG_DS_COMMAND: 
	    case MSG_DS_KEY_DOWN:
		flag=0;
	        DsBeepOn(2);
		break;
	  }
	}
}
