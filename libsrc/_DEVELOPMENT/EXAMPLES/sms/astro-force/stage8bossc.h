void InitStage8BossC(enemy *en)
{
	en->enemyframe=(en->enemyposx-32)>>2; // 32-112-192
}


void FinishStage8BossC()
{
	if(numenemies==0)
	{
		disablescroll=0;
	
		// Change stage 8 phase
		stage8phase=2;
	
		// The frames
		stageframe=0;
	}
}

unsigned char UpdateStage8BossC(enemy *en)
{
	unsigned char a;
	
	if(disablescroll==0)
	{
		en->enemyposy++;
		if(en->enemyposy==24+32)disablescroll=1;
	}
	else
	{
		// Shoot?
		if(numenemies>1)
		{
			if(en->enemyframe%64>=40)
				TestEnemyShootComplex(en,6,12,24);
		}
		else
		{
			if(en->enemyposx!=112)
			{
				if(en->enemyframe%4==0)
				{
					a=(en->enemyframe%64)>>2;
					if(en->enemyposx<128)
						InitEnemyshootDirection(en->enemyposx+12, en->enemyposy+24, stage8bosscshootspeedx[a], stage8bosscshootspeedy[a]);
					else
						InitEnemyshootDirection(en->enemyposx+12, en->enemyposy+24, -stage8bosscshootspeedx[a], stage8bosscshootspeedy[a]);
				}
			}
		}
	}
		
	// Draw
	DrawSpriteArray(STAGE8BOSSCBASE,en->enemyposx,en->enemyposy,32,32);
	
	// Return
	return 1;
}
