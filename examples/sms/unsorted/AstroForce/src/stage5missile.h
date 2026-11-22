unsigned char UpdateStage5Missile(enemy *en)
{
	// Update speed
	if(en->enemyframe%2==0)
		en->enemyparama++;
	
	// Check exit
	if(en->enemyposy<(en->enemyparama-4))return 0;
		
	// Move
	en->enemyposx+=en->enemyparamb-2;
	en->enemyposy+=4-en->enemyparama;
	
	// Draw sprite
	SMS_addSprite(en->enemyposx,en->enemyposy,(int)(STAGE5MISSILEBASE));
	SMS_addSprite(en->enemyposx,en->enemyposy+8,(int)(STAGE5MISSILEBASEB));
//	SMS_addSprite(en->enemyposx,en->enemyposy+16+(stageframe4mod<<2),STAGE5MISSILEBASE+2);

	// Exit
	return 1;
}

