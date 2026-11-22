

int func1(int a)
{
   if ( a == 10 ) return func1(a);

   return a;
}

int func1a(int a)
{
   if ( 10 == a ) return func1(a);

   return a;
}

int func1b(int a)
{
   return 1  == a;
}


int func1c(int a)
{
   return a == 1;
}

int func2(int a)
{
   if ( a != 10 ) return func1(a);

   return a;
}

int func2a(int a)
{
   if ( 10 != a ) return func1(a);

   return a;
}


int func2c(int a)
{
   return 1 != a;
}


int func2d(int a)
{
   return a != 1;
}
