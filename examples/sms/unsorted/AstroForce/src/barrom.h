signed char barromx[]={-3,3,-3,3,-2,2,-2,2,-1,1,-1,1};
signed char barromy[]={3,-3,3,-3,-2,2,2,-2,1,-1,-1,1};
unsigned char barromtime;

void UpdateBarrom()
{
	if(barromtime<24)
	{
		// Update scroll
		UpdateScroll((barromx[barromtime>>1]+(mappositionx>>2))%256,(barromy[barromtime>>1]+(mappositiony>>2))%224);
		barromtime++;
	}
}

void DoBarrom()
{
	barromtime=0;
}

void InitBarrom()
{
	barromtime=24;
}