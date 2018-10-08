/*
 *
 *        ROMAN.C  -  Converts integers to Roman numerals
 *
 *             Written by:  Jim Walsh
 *
 *             Compiler  :  Microsoft QuickC v2.5
 *
 *        This Program Is Released To The Public Domain
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

//int main( int argc, char *argv[] )

main(argc, argv)
int argc;
char *argv[];
{
    int value, dvalue;
    char roman[80];
    roman[0] = '\0';
    if( argc == 2 )
        value = atoi( argv[1] );
    else
    {
        printf( "\nEnter an integer value: " );
        scanf( "%d", &value );
    }
    dvalue = value;
    while( value >= 1000 )
    {
        strcat( roman, "M" );
        value -= 1000;
    }
    if( value >= 900 )
    {
        strcat( roman, "CM" );
        value -= 900;
    }
    while( value >= 500 )
    {
        strcat( roman, "D" );
        value -= 500;
    }
    if( value >= 400 )
    {
        strcat( roman, "CD" );
        value -= 400;
    }
    while( value >= 100 )
    {
        strcat( roman, "C" );
        value -= 100;
    }
    if( value >= 90 )
    {
        strcat( roman, "XC" );
        value -= 90;
    }
    while( value >= 50 )
    {
        strcat( roman, "L" );
        value -= 50;
    }
    if( value >= 40 )
    {
        strcat( roman, "XL" );
        value -= 40;
    }
    while( value >= 10 )
    {
        strcat( roman, "X" );
        value -= 10;
    }
    if( value >= 9 )
    {
        strcat( roman, "IX" );
        value -= 9;
    }
    while( value >= 5 )
    {
        strcat( roman, "V" );
        value -= 5;
    }
    if( value >= 4 )
    {
        strcat( roman, "IV" );
        value -= 4;
    }
    while( value > 0 )
    {
        strcat( roman, "I" );
        value--;
    }
    printf( "\n%d = %s\n", dvalue, roman );
    return(0);
}
