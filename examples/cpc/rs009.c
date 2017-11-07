/*
	009 - Keyboard
	CPCRSLIB demo
	
	zcc +cpc -lndos -create-app -Cz--audio -lm rs009.c
 */

 #include <cpc.h>


main()
{
	cpc_PrintStr("Press a Key to redefine as #1");
	cpc_RedefineKey(0);		//redefine key. There are 12 available keys (0..1)
	cpc_PrintStr("Done!");
	

	cpc_PrintStr("Press any key");
	while(!(cpc_AnyKeyPressed())){}
	
	cpc_PrintStr("fine! try again");
	
	cpc_PrintStr("Press any key to continue");
	while(!(cpc_AnyKeyPressed())){}
	
	
	cpc_PrintStr("Press a Key to redefine as #2");
	cpc_RedefineKey(3);		//redefine key. There are 12 available keys (0..1)
	cpc_PrintStr("Done!");
	
	#asm

	._kkk
	ld b,100
	.llll
	halt
	djnz llll
	#endasm


	cpc_SetBorder(3);
	
	
	cpc_PrintStr("Press a Key to test it..");
	while (1) {
		if (cpc_TestKey(0)) {	//test if the key has been pressed.
			cpc_PrintStr("OK Key #1");
			}
		if (cpc_TestKey(3)) {	//test if the key has been pressed.
			cpc_PrintStr("OK Key #2");
			}			
			//else cpc_PrintStr(no);
	}
	
	
}

