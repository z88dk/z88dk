#define MAXSTAGE3STARS 6
#define MAXSTAGE5CLOUDS 2

typedef struct stage3star
{
	unsigned char posx;
	unsigned char posy;
	unsigned char speed;
}stage3star;
stage3star stage3stars[MAXSTAGE3STARS];

void InitStage3Star(stage3star *st,unsigned char speed)
{
	st->posx=48+(myRand()%(255-48-48-16));
	st->posy=myRand()%192;
	st->speed=speed;
}

void UpdateStarMovement(stage3star *st)
{
	st->posy+=st->speed;
	if(st->posy==191)
		st->posx=48+(myRand()%(255-48-48-16));
}

void UpdateStage3Star(stage3star *st)
{
	SMS_addSprite(st->posx,st->posy,(int)(STAGE3STARBASE));
	UpdateStarMovement(st);
}

void UpdateStage5Cloud(stage3star *st)
{
	DrawSpriteArray(STAGE5CLOUDBASE,st->posx-16,st->posy,32,8);
	UpdateStarMovement(st);
}
