void resultif();
void resultelse();
void resultelseif();

int var;

int func1() 
{
	if ( 1 )  {
		resultif();
	} else {
		resultelse();
	}
}


int func1a() 
{
	if ( 1 )  {
		resultif();
	}
}

int func1b() 
{
	if ( 1 )  {
		resultif();
	} else if ( 1 ) {
		resultelseif();
        } else {
		resultelse();
	}
}

int func1c() 
{
	if ( var++, 1 )  {
		resultif();
	}
}


int func2() 
{
	if ( 0 )  {
		resultif();
	} else {
		resultelse();
	}
}

int func2a() 
{
	if ( 0 )  {
		resultif();
	}
}
int func2b() 
{
	if ( var++, 0 )  {
		resultif();
	}
}


int func3() 
{
	int	a;
	if ( a )  {
		resultif();
	} else {
		resultelse();
	}
}

int func3a() 
{
	int	a;
	if ( a )  {
		resultif();
	}
}
