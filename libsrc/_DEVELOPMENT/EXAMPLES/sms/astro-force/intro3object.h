void InitIntro3Object(enemy *en)
{
	PlayMusic(intro3_psg,intro3_psg_bank,0);
}
	
void DrawIntro3Object(unsigned int *d,unsigned char i,unsigned char l)
{
	unsigned char b,c;
	
	// Rom bank
	changeBank(persons_bin_bank);

	// Images
	for(b=0;b<6;b++)
	{
		SMS_setNextTileatXY(i,b+2);
		for(c=0;c<l;c++)
			SMS_setTile(*d++);
		d+=18-l;
	}
	changeBank(FIXEDBANKSLOT);
}

void UpdateIntro3Object1(enemy *en)
{
	if(en->enemyframe==16)
	{
		DrawIntro3Object(persons_bin+2,7,6);
		en->enemyparama++;
		en->enemyframe=0;
	}
}

void UpdateIntro3Object2(enemy *en)
{
	if(en->enemyframe==160)
	{
		DrawIntro3Object(persons_bin+14,19,6);
		en->enemyparama++;
		en->enemyframe=0;
	}
}

void UpdateIntro3Object3(enemy *en)
{
	if(en->enemyframe==160)
	{
		DrawIntro3Object(persons_bin+216,7,18);
		en->enemyparama++;
		en->enemyframe=0;
	}
}

unsigned char UpdateIntro3Object(enemy *en)
{
	// Call custom function
	if(en->enemyparama<3)
	{
		//changeBank(FIXEDBANKSLOT);
		(*(updateintro3objectfunctions[en->enemyparama]))(en);
	}
	
	// Return
	return 1;
}


