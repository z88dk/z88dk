void ClearTimeredLabelLine(unsigned char y)
{
	// Clear line
	SMS_setNextTileatXY (0,y);
	for(unsigned char a=0;a<32;a++)SMS_setTile(0);
}

// Remove timered label
void RemoveTimeredLabel(signed char a)
{
	timeredlabel *tla,*tlb;

	// Get first
	tla=&timeredlabels[a];
	
	// Clear line
	ClearTimeredLabelLine(tla->timeredlabely);
	
	// Remove list of sprites
	if(a<numtimeredlabels-1)
	{
		// Get last
		tlb=&timeredlabels[numtimeredlabels-1];
		
		tla->timeredlabely=tlb->timeredlabely;
		tla->timeredlabelt=tlb->timeredlabelt;
	}
	// Bajamos el numero de labels
	numtimeredlabels--;
}

// Update label
void UpdateTimeredLabel(signed char a)
{
	timeredlabel *tl;
	
	tl=&timeredlabels[a];
	
	tl->timeredlabelt--;
	if(tl->timeredlabelt==0)
		RemoveTimeredLabel(a);
}

// Update all labels
void UpdateTimeredLabels()
{
	if(numtimeredlabels>0)
		for(signed char a=numtimeredlabels-1;a>=0;a--)
			UpdateTimeredLabel(a);
}

// Create a label
void InitTimeredLabel(unsigned char *s,unsigned char y,signed int t)
{
	timeredlabel *tl;
	
	if(numtimeredlabels<MAXTIMEREDLABELS)
	{
		// Get slot
		tl=&timeredlabels[numtimeredlabels];
		
		// Set data
		tl->timeredlabely=y;
		tl->timeredlabelt=t;
		
		// Increase counter
		numtimeredlabels++;
		
		// Clear line
		ClearTimeredLabelLine(y);
		
		// Centered text
		WriteText(s,16-(strlen(s)>>1),y);
	}		
}

// Init all enemys
void InitTimeredLabels()
{
	numtimeredlabels=0;
}

