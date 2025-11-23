void InitScripts()
{
	numscripts=0;
}

void InitScript(unsigned char *scripter,unsigned char **labels)
{
	script *sc;
	
	if(numscripts<MAXSCRIPTS)
	{
		// Get script
		sc=&scripts[numscripts++];

		// Data
		sc->scripterpass=0;
		sc->scripterframe=0;
		sc->scripterscript=scripter;
		sc->scripterlabels=labels;
		sc->scripterloop=-1;
	}
}

// Remove enemy
void RemoveScript(signed char a)
{
	script *sa,*sb;
	
	// Remove list of scripts
	if(a<numscripts-1)
	{
		sa=&scripts[a];
		sb=&scripts[numscripts-1];
		
		sa->scripterpass=sb->scripterpass;
		sa->scripterscript=sb->scripterscript;
		sa->scripterlabels=sb->scripterlabels;
		sa->scripterframe=sb->scripterframe;
		sa->scripterloop=sb->scripterloop;
	}
	// Bajamos el numero de enemys
	numscripts--;
}

void UpdateScript(unsigned char a)
{
	unsigned char sf;
	unsigned char *ss;
	unsigned char sa,sb,sc;
	unsigned int sp;
	script *scr;
		
	// Get script
	scr=&scripts[a];
	
	// Now we can
	scr->scripterframe++;

	// Get data
	sf=scr->scripterframe;
	sp=scr->scripterpass;
	ss=scr->scripterscript;
	
	// Activate all events
	while(ss[sp]==sf)
	{
		sa=ss[sp+2];
		sb=ss[sp+3];
		sc=ss[sp+4];
		
		switch(ss[sp+1])
		{
			case SCRIPT_ADVANCESCROLLER:
				updatescrollact();
			break;
			case SCRIPT_INITSCRIPT:
				InitScript((unsigned int *)spawners[sa],0);
			break;
			case SCRIPT_SETLABEL:
				InitTimeredLabel(scr->scripterlabels[sa],sb,sc);
			break;
			case SCRIPT_INITENEMY:
				InitEnemy(sb,sc,sa);
			break;
			case SCRIPT_SETPALETTE:
				SMS_setBGPaletteColor (sa,sb);
			break;
			case SCRIPT_FILLBACKGROUND:
				fillBackground();
			break;
			case SCRIPT_KILLENEMIES:
				InitEnemies();
			break;
			case SCRIPT_LOOP:
				// Si no está en loop, pasamos
				if(scr->scripterloop==-1)
				{
					scr->scripterloop=sc;
					scr->scripterpass-=(sb*5);
					scr->scripterframe=(sa-1);
					return;
				}
				else
				{
					scr->scripterloop--;
					if(scr->scripterloop>=0)
					{
						scr->scripterpass-=(sb*5);
						scr->scripterframe=(sa-1);
						return;
					}
				}
			break;
			case SCRIPT_SETEXPLOSION:
				InitExplosion(sa,sb,sc);
			break;
			case SCRIPT_END:
				RemoveScript(a);
				return;
			break;
		}
		sp+=5;
		scr->scripterpass+=5;
	}
}

// Update all scripts
void UpdateScripts()
{
	signed char q;
	
	// Hey hey hey they all are in fixedbank!!!
	changeBank(FIXEDBANKSLOT);
	
	// For each script
	if(numscripts>0)
		for(q=numscripts-1;q>=0;q--)
			UpdateScript(q);
}
