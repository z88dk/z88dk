void InitScroller()
{
	numscrolls=0;
	scrollactspeedx=0;
	scrollactspeedy=0;
	scrollact=0;
	disablescroll=0;
	scrolltimes=0;
}

void AddScrollers(signed int *scr,unsigned char num)
{
	scrolls=(scroll *)scr;
	numscrolls=num;
}

void UpdateScroller()
{
	scroll *sc;
	
	if(disablescroll==0)
	{
		// The bank
		changeBank(FIXEDBANKSLOT);
		
		// Get scroll
		sc=&scrolls[scrollact];
		
		// To get a sweet scroll...
		if(stageframe4mod==0)
		{
			scrollactspeedx+=(scrollactspeedx<sc->scrollspeedx)?1:(scrollactspeedx>sc->scrollspeedx)?-1:0;
			scrollactspeedy+=(scrollactspeedy<sc->scrollspeedy)?1:(scrollactspeedy>sc->scrollspeedy)?-1:0;
		}

		// Update map position
		if(mappositiony-scrollactspeedy<sc->scrolllock)
		{
			mappositiony+=sc->scrolljump;
			oldmappositiony+=sc->scrolljump;
			
			scrolltimes++;
			if(scrolltimes==sc->scrolltimes)
			{
				scrolltimes=0;
				scrollact++;
				if(scrollact>=numscrolls)
					disablescroll=1;
			}
		}
		// Map
		MoveMap(scrollactspeedx,-scrollactspeedy); 
	}
}

void updatescrollact()
{
	scrollact++;
	scrolltimes=0;
}

