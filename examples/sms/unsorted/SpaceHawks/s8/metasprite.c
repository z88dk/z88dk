#include <arch/sms/SMSlib.h>
#include "metasprite.h"

void addMetaSprite(metaSprite *msprite) 
{
	unsigned char i;
	unsigned char count = msprite->nbSprites;
	subSprite *sub;

	sub = & (*msprite->sprites)[0];
	for (i = 0; i< count; i++)
	{
		SMS_addSprite(	sub->xOffset + msprite->x,
						sub->yOffset + msprite->y,
						sub->tileOffset + msprite->tile );
		sub++;
	}
}

void updateMetaSpritePos(metaSprite *msprite) 
{
	unsigned char i;
	unsigned char count = msprite->nbSprites;
	subSprite *sub;

	sub = & (*msprite->sprites)[0];

	for (i = 0; i< count; i++)
	{
		SMS_updateSpritePosition(	sub->reservedSprite,
						sub->xOffset + msprite->x,
						sub->yOffset + msprite->y);
		sub++;
	}
}


void updateMetaSpriteTile(metaSprite *msprite) 
{
	unsigned char i;
	unsigned char count = msprite->nbSprites;
	subSprite *sub;

	sub = & (*msprite->sprites)[0];

	for (i = 0; i< count; i++)
	{
		SMS_updateSpriteImage(sub->reservedSprite, 
								sub->tileOffset + msprite->tile );
		sub++;
	}
}
