#ifndef SCREEN_H_
#define SCREEN_H_

#include "types.h"

typedef struct
{
		unsigned char uid; 		//unique ID, to help identify the active screen
		_voidCallback *init;	//func called on init
		_voidCallback *update; //func called between 2 vblank
		_voidCallback *updateVBlank; //func called each vblank
		_voidCallback *updateHBlank; //func called each hblank
		_voidCallback *close; //func called before moving to another screen
}gameScreen;


void SCREEN_setCurrent( gameScreen *screen );
bool SCREEN_isCurrent( unsigned id  ) __z88dk_fastcall;
void SCREEN_update( );
void SCREEN_updateVBlank(  );
void SCREEN_updateHBlank(  );


#endif /* SCREEN_H_ */
