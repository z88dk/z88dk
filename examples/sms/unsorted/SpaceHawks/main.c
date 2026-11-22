#include <arch/sms/SMSlib.h>
#include "s8/types.h"
#include "screens/screenManager.h"

//(almost) totally random ID selected one day
//I'll use it as basis for all (!) my releases
#define SPRITESMIND_ID	12212
#ifdef TARGET_GG
#define RELEASE_ID		3 //my third rom (SMS rom +1)
#else
#define RELEASE_ID		2 //my second rom so +2
#endif

//optional
#ifdef TARGET_GG
const unsigned char sh_name[] = "GG Space Hawks";
const unsigned char sh_author[] = "KanedaFr";
const unsigned char sh_description[] = "unofficial GameGear port";
#else
const unsigned char sh_name[] = "Space Hawks";
const unsigned char sh_author[] = "KanedaFr";
const unsigned char sh_description[] = "unofficial port";
#endif


void main()
{
	//don't scroll hud ;)
	SMS_VDPturnOnFeature(VDPFEATURE_LOCKHSCROLL);
	
	setCurrentScreen(SPRITESMIND_SCREEN);

	while (true)
	{
		SMS_waitForVBlank();
		
		SCREEN_update();
	}
}
