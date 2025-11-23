void InitWarning(enemy *en)
{
	PlayMusic(norefuge_psg,norefuge_psg_bank,0);
}
			
unsigned char UpdateWarning(enemy *en)
{
	unsigned int s;

	
	if(en->enemyframe==120)
	{
		if(en->enemyposx==0)
		{
			if(playstage%2==0)
				PlayMusic(boss_psg,boss_psg_bank,1);
			else
				PlayMusic(boss2_psg,boss2_psg_bank,1);
		}
		if(en->enemyposx==2)
			PlayMusic(flight_psg,flight_psg_bank,1);
		return 0;
	}
	
	if(en->enemyframe<96)
	{
		if((en->enemyframe>>4)%2==0)
		{
			s=WARNINGBASE;
			for(unsigned char y=0;y<16;y+=8)
				for(unsigned char x=0;x<56;x+=8)
					SMS_addSprite(104+x,92+y,s++);
		}
	}
	
	return 1;
}

