void InitStageSprite(unsigned char b)
{
	const unsigned char *pointer;
	int base;
	char bank;
	
	pointer=imagepointers[b];
	base=imagebases[b];
	bank=imagebanks[b];
	LoadSprite((unsigned char *)pointer,base,bank);
}

void InitStageSprites(const unsigned char *spl,unsigned char num)
{
	for(unsigned char a=0;a<num;a++)
	{
		changeBank(FIXEDBANKSLOT);
		InitStageSprite(spl[a]);
	}
}

void InitAfterBossStage()
{
	// Destroy all enemies
	KillEnemyshoots();
	KillEnemies(1);

	// Music
	PSGStop();
	
	// Exit
	playertype=5;
	playercounter=0;
}
	
void InitCustomStageData()
{
	// Metemos aquí la velocidad de los disparos, ya que en alguna fase la retocamos
	playstageshootspeed=DEFAULTENEMYSHOOTSPEED+gamelevel;

	// Change bank
	changeBank(FIXEDBANKSLOT);

	// Custom Init
	(*(initstagefunctions[playstage]))();
}

void UpdatePlayStage()
{
	// Change bank
	changeBank(FIXEDBANKSLOT);

	// Custom Update
	(*(updatestagefunctions[playstage]))();
}

void InitStageData(unsigned int i)
{
	unsigned char *palette_bin;
	unsigned int palette_bin_bank;
	unsigned char *tilemap_l;
	unsigned int tilemap_l_size;
	unsigned char *tilemap_m;
	unsigned char *psg;
	unsigned int psg_bank;
	unsigned char loop_psg;
	
	// Prevent errors
	changeBank(FIXEDBANKSLOT);
	
	// Update where we stay
	i<<=3;

	// Get all data
	palette_bin=(unsigned char *)stageinitdata[i];i++;
	palette_bin_bank=(unsigned int)(stageinitdata[i]);i++;
	tilemap_l=(unsigned char *)stageinitdata[i];i++;
	tilemap_l_size=(unsigned int)(stageinitdata[i]);i++;
	tilemap_m=(unsigned char *)stageinitdata[i];i++;
	psg=(unsigned char *)stageinitdata[i];i++;
	psg_bank=(unsigned int)(stageinitdata[i++]);
	loop_psg=(unsigned int)(stageinitdata[i]);


	// The bank
	playstagebank=palette_bin_bank;
	
	// Load palette
	LoadBGPalette(palette_bin,palette_bin_bank);

	// The tilemap
	SetMapLines(tilemap_l,tilemap_l_size,tilemap_m);

	// Init map
	InitMap(palette_bin_bank);

	// Rom bank
	if(psg!=0)
		PlayMusic(psg,psg_bank,loop_psg);
}

// Pass A
void UpdateStagePassA()
{
	// Player indicators
	UpdatePlayerIndicators();

	// Update powerups
	UpdatePowerup();

	// Update player
	UpdatePlayer();

	// Update player shoots
	UpdatePlayershoots();	

	// Enemy shoots
	UpdateEnemyshoots();

	// Update explosions
	UpdateExplosions();
}

		
void UpdateStagePassB()		
{
	// Enemies!!!
	UpdateEnemies();
}
		
// Pantalla de juego
void InitPlayStage()
{
	// Save continue stage, for continue :)
	laststagenum=stagenum;
	
	// Init stage
	InitStage();

	// Init script
	InitScripts();
	
	// Enemies set to 0
	InitEnemies();
	
	// And enemy shoots
	InitEnemyshoots();
	
	// Lo volvemos a apagar
	SMS_displayOff();

	// Scroller
	InitScroller();

	// Barrom
	InitBarrom();
	
	// Let's fill playstage
	if(stagenum<6)
		playstage=1+((basestage+stagenum)%5);
	else
		playstage=stagenum;

	// Last but not least, load custom stage data from array data
	InitStageData(stagedatamarks[playstage-1]);

	// For the stage custom code 
	InitCustomStageData();
	
	// Init player
	InitPlayerSprite();

	// Init player shoots
	InitPlayershoots();

	// Init powerup
	InitPowerups();

	// Init explosion sprite
	InitExplosions();
	
	// Do what we have to do
	InitPlayer();

	// Lo volvemos a encender
	SMS_displayOn();

	// Exit stage flag
	exitplaystage=0;
	
	// To make update at init
	updateplaystage=1;
	
	// We have not pause
	gamepause=0;

	// Bucle
	while(1)
	{
		// Check for game pause
		checkgamepause();
		
		if(gamepause==0)
		{
			// Update stage
			UpdateStage();
			
			// Scroller... note this is processed ***ALWAYS*** to do a sweet effect
			UpdateScroller();

			// Barrom
			UpdateBarrom();
			
			// Alternamos
			if(stageframe2mod==0)
				UpdateStagePassA();
			else
				UpdateStagePassB();

			// Scripter
			if((stageframe%16)==0)
				UpdateScripts();
			
			// Hay que salirse?
			if(exitplaystage==1)return;

			// Update psg
			UpdatePSG();
		}
		else
		{
			// Update psg
			UpdatePSG();
			
			// Wait
			SMS_waitForVBlank();
		
			// Reset
			numinterrupts=0;
		}
	}
}
