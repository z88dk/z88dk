/*
	REL file analyzer: generates binary blocks which can be disassembled
	by Enrico Maria Giordano and Stefano Bodrato
	This file is part of the Z88 Developement Kit  -  http://www.z88dk.org

	$Id: REL2BIN.C,v 1.2 2006-03-17 08:07:35 stefano Exp $
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LabelCount 0xf000

char ModuleName[256];

int counter = 0;
int PSize, DSize;
int locator;
int labelcnt = LabelCount;

static int LastAddressType = 0;

static int CurrByte = 0;
static int CurrBit = -1;

static int Pass = 2;


int ReadOneBit( FILE *FilePtr, int Boundary )
{

    int Bit;

    if ( CurrBit == -1 || Boundary )
    {
        CurrByte = fgetc( FilePtr );
        CurrBit = 7;
        if ( Boundary ) return 0;
    }

    Bit = ( CurrByte & 128 ) == 128;

    CurrByte *= 2;

    --CurrBit;

    return Bit;
}


int ReadBits( FILE *FilePtr, int ToRead )
{
    int Bits = 0;

    int i;

    for ( i = 0; i < ToRead; ++i )
        Bits = Bits * 2 + ReadOneBit( FilePtr, 0 );

    if ( ToRead == 16 )
        Bits = ( Bits >> 8 ) + ( ( Bits & 255 ) << 8 );

    return Bits;
}


int WriteBlock ( char *ModuleName, unsigned char segment[], int size )
{
    FILE *fpout;

    if ( ( fpout = fopen( ModuleName, "wb" ) ) == NULL ) {
	printf("Can't open output file '%s'\n",ModuleName);
	exit(1);
    }

    for (locator = 0; locator < size; locator++)
    {
    	fputc (segment[locator],fpout);
	printf ("%u ", segment[locator]);
    }
    
    fclose (fpout);

    printf ("\n\n\n");
}


int SwitchPass ( FILE *FilePtr )
{
static int svByte, svBit, svFile;
static int svCounter;

    switch ( Pass )
    {
        case 1:
	    // Pass 2: pre-link and load data basing on "PSize" and "DSize"
	    CurrByte = svByte;
	    CurrBit = svBit;
	    fseek ( FilePtr, svFile, SEEK_SET );
	    counter=svCounter;
            Pass = 2;
            
            break;
        case 2:
            // Pass 1: find the Data and Program size
            DSize = 0;
            PSize = 0;
            svByte = CurrByte;
            svBit = CurrBit;
            svCounter = counter;
            svFile = ftell( FilePtr );
            Pass = 1;

            break;
    }
    
    printf ( "Switched to pass %u\n", Pass );
    return ( Pass );
}


char *ReadStr( FILE *FilePtr, char *Buffer, int Length )
{
    int i;

    for ( i = 0; i < Length; ++i )
    {
        Buffer[ i ] = ( char ) ReadBits( FilePtr, 8 );
        if ( Buffer[ i ] == '$' ) Buffer[ i ] = 'S';
        if ( Buffer[ i ] == '.' ) Buffer[ i ] = '_';
        if ( Buffer[ i ] == '?' ) Buffer[ i ] = 'X';
        if ( Buffer[ i ] == '@' ) Buffer[ i ] = 'A';
    }

    Buffer[ Length ] = '\0';

    return Buffer;
}


char *AddressType( char *Buffer, int Type )
{

    switch ( Type )
    {
        case 0:
            strcpy( Buffer, "AB" );
            break;
        case 1:
            strcpy( Buffer, "PR" );
            break;
        case 2:
            strcpy( Buffer, "DR" );
            break;
        case 3:
            strcpy( Buffer, "CR" );
            break;
    }


    return Buffer;
}


int ReadAddress ( FILE *FilePtr, char *Type )
{
    int AType;
    int Address;
    
    AType = ReadBits( FilePtr, 2 );

    LastAddressType = AType;

    Address = ReadBits( FilePtr, 16 );
    Type = AddressType( Type, AType );
        
    return Address;
}


int ReadLink( FILE *FilePtr, unsigned char segment[] )
{
    char Name[ 256 ];

    char Type[ 3 ];

    int Address, PtrNext;

    if ( ( Pass == 1 ) && ( PSize != 0 ) && ( DSize != 0 ) ) 
    {
    	printf ("\nProgram Size: %d  Data Size: %d\n\n", PSize, DSize);
    	SwitchPass ( FilePtr );
    	
    	return 1;
    }

    //printf ( "Pass %d :", Pass );

    switch ( ReadBits( FilePtr, 4 ) )
    {
        case 0:
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

            if ( Pass == 2 )
              printf( "Entry symbol: %s\n", Name );

            break;
        case 1:
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

            if ( Pass == 2 )
              printf( "Select common block: %s\n", Name );

            break;
        case 2:
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

            if ( Pass == 2 )
              printf( "Program name: %s\n", Name );

            break;
        case 3:
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );
            if ( Pass == 1 )
              printf( "Special item 0011. External library request: %s\n\n", Name );
            
            //exit( 1 );

            break;
        case 4:
            if ( Pass == 1 )
              printf( "Warning: unused special item 0100\n" );
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );
            if (Pass == 1)
              printf( "Item name: %s \n\n", Name );

            //exit( 1 );

            break;
        case 5:
            Address = ReadAddress ( FilePtr, Type );
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

            if ( Pass == 2 )
              printf( "Common block size: %s %d [%s]\n", Name, Address, Type );

            break;
        case 6:
            Address = ReadAddress ( FilePtr, Type );
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

            //printf( "Chain external: %s %d [%s]", Name, Address, Type );
            if ( Pass == 2 )
              printf( "Chain external: %s %x [%s]", Name, labelcnt, Type );

	    while ((Address != 0) && (Address<60000))
	    {
	        PtrNext = segment[Address] + 256 * segment[Address+1];
                if ( Pass == 2 )
	          printf(" - %u -", PtrNext);
	        segment[Address] = labelcnt & 255;
	        segment[Address+1] = labelcnt >> 8;
	        //printf("%u\n\n",PtrNext);
	        Address = PtrNext;
	    }
	    
	    labelcnt++;
            if ( Pass == 2 )
              printf( "\n" );

            break;
        case 7:
            Address = ReadAddress ( FilePtr, Type );
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

            if ( Pass == 2 )
              printf( "Entry point: %s %d [%s]\n", Name, Address, Type );

	    // STE  -- Nome blocco = a ultimo entry point trovato
       	    sprintf (ModuleName,"%s",Name);

            break;
        case 8:
            if ( Pass == 2 )
              printf( "Error: unused special item 1000\n" );

            exit( 1 );

            break;
        case 9:
            Address = ReadAddress ( FilePtr, Type );

            if ( Pass == 2 )
              printf( "External offset: %d [%s]\n", Address, Type );

            break;
        case 10:
            Address = ReadAddress ( FilePtr, Type );

            if ( Pass == 2 )
              printf( "Data size: %d [%s]\n", Address, Type );
            if ( (Pass == 1) && (DSize == 0) ) DSize = Address;

            break;
        case 11:
            Address = ReadAddress ( FilePtr, Type );

            if ( Pass == 2 )
              printf( "Location counter: %d [%s]\n", Address, Type );

            // ****
            if ( LastAddressType == 2 )
		counter = ( Address + PSize );
	    else
		counter = Address;

            break;
        case 12:
            Address = ReadAddress ( FilePtr, Type );

            if ( Pass == 2 )
              printf( "Chain address: %d [%s]\n", Address, Type );
	    
	    // STE
	    segment[Address] = counter & 255;
	    segment[Address+1] = counter >> 8;
            //printf( "Chain external: %s %d [%s]", Name, Address, Type );
            //if ( Pass == 2 )
            //  printf( "Chain external: %s %x [%s]", Name, labelcnt, Type );

            break;
        case 13:
            Address = ReadAddress ( FilePtr, Type );

            if ( Pass == 2 )
              printf( "Program size: %d [%s]\n", Address, Type );
            if ( (Pass == 1) && (PSize == 0) ) PSize = Address;

            break;
        case 14:
            Address = ReadAddress ( FilePtr, Type );

            printf( "End module: %d [%s]\n\n", Address, Type );

            if ( Pass == 2 )
            {
	        WriteBlock ( ModuleName, segment, PSize + DSize );
	    }

            ReadOneBit( FilePtr, 1 );

	    SwitchPass ( FilePtr );

            break;
        case 15:
           printf( "End file\n" );

            return 0;

            break;
    }

    return 1;
}


int ReadItem( FILE *FilePtr )
{
    unsigned char byt;
    int RelPtr;

    unsigned char segment[64000];

    if ( ReadBits( FilePtr, 1 ) == 0 )
    {
        // printf( "[LC] %d\n", ReadBits( FilePtr, 8 ) );
        //printf( "%d\n", ReadBits( FilePtr, 8 ) );
        byt = ReadBits( FilePtr, 8 );
        if (LastAddressType == 2)
        {
        	if ((byt > 31) && (byt < 128))
                   if (Pass == 2)
                     printf( "[%d]{%d} %d \t%c\n", counter, LastAddressType, byt, byt);
        	else
                   if (Pass == 2)
                     printf( "[%d]{%d} %d \t-\n", counter, LastAddressType, byt);
        	//printf( "[%d]{%d} %d\n", counter, LastAddressType, byt);
        	segment[ counter ] = byt;
        }
        else
        {
                if (Pass == 2)
                  printf( "[%d]{%d} %d\n", counter, LastAddressType, byt);
        	segment[counter] = byt;
        }
        counter++;
    }
    else
    {
        switch ( ReadBits( FilePtr, 2 ) )
        {
            case 0:
                if ( !ReadLink( FilePtr, segment ) ) return 0;

                break;
            case 1:
            	RelPtr = ReadBits( FilePtr, 16 );
                if (Pass == 2)
                  printf( "[%d PS] %d\n\n", counter, RelPtr );
                segment[counter] = RelPtr & 255;
                segment[counter+1] = RelPtr >> 8;
		counter = counter +2;
		
                break;
            case 2:
            	RelPtr = ReadBits( FilePtr, 16 );
                if (Pass == 2)
                  printf( "[%d DS] %d\n\n", counter, RelPtr );
                // ****
                segment[counter] = ( PSize + RelPtr ) & 255;
                segment[counter+1] = ( PSize + RelPtr ) >> 8;
		counter = counter +2;
		
                break;
            case 3:
            	RelPtr = ReadBits( FilePtr, 16 );
                if (Pass == 2)
                  printf( "[%d CB] %d\n\n", counter, RelPtr );
                segment[counter] = RelPtr & 255;
                segment[counter+1] = RelPtr >> 8;
		counter = counter +2;		
		
                break;
        }
    }
    return 1;
}


int main( int argc, char *argv[] )
{
    FILE *RelFile;

    if ( argc != 2 )
    {
        printf( "Usage: rel2bin <REL library filename>\n" );
        return 1;
    }

    RelFile = fopen( argv[ 1 ], "rb" );

    if ( !RelFile )
    {
        printf( "Can't open file %s\n", argv[ 1 ] );
        return 1;
    }

    SwitchPass ( RelFile );
    while ( ReadItem( RelFile) );
    fclose( RelFile );

    return 0;
}
