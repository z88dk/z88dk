/*
	REL to Z80ASM format library converter by Enrico Maria Giordano 
	This file is part of the Z88 Developement Kit  -  http://www.z88dk.org

	$Id: REL2Z80.C,v 1.2 2005-06-30 17:00:29 stefano Exp $
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


struct ExpDecl
{
    int Address;
    char Name[ 8 ];
    struct ExpDecl *Next;
};


struct NameDecl
{
    char Name[ 8 ];
    struct NameDecl *Next;
};


struct LibNameDecl
{
    char Name[ 8 ];
    struct LibNameDecl *Next;
};


struct Z80Module
{
    int OrgAddress;
    int ModuleNamePtr;
    int ExpDeclPtr;
    int NameDeclPtr;
    int LibNameDeclPtr;
    int DataBlockPtr;
    struct ExpDecl *ExpDecl;
    struct NameDecl *NameDecl;
    struct LibNameDecl *LibNameDecl;
    char ModuleName[ 8 ];
    int DataBlock[ 65536 ];
    int DataBlockSize;
    int DataSize;
};


void AddExpDecl( struct Z80Module *Z80Module, int Address, char *Name )
{
    struct ExpDecl *Tmp = Z80Module -> ExpDecl;
    struct ExpDecl *New;

    New = malloc( sizeof( struct ExpDecl ) );

    New -> Address = Address;
    strcpy( New -> Name, Name );
    New -> Next = 0;

    if ( !Tmp )
    {
        Z80Module -> ExpDecl = New;
        return;
    }

    while ( Tmp -> Next ) Tmp = Tmp -> Next;

    Tmp -> Next = New;
}


void CompleteExpDecl( struct Z80Module *Z80Module )
{
    struct ExpDecl *Tmp = Z80Module -> ExpDecl;

    int Address, TmpAddr;

    while ( Tmp )
    {
        Address = Tmp -> Address;

        while ( ( TmpAddr = Z80Module -> DataBlock[ Address ] + 256 * Z80Module -> DataBlock[ Address + 1 ] ) != 0 )
        {
            Z80Module -> DataBlock[ Address ] = 0;
            Z80Module -> DataBlock[ Address + 1 ] = 0;

            Address = TmpAddr;

            AddExpDecl( Z80Module, Address, Tmp -> Name );
        }

        Tmp = Tmp -> Next;
    }
}


int GetExpDeclLen( struct Z80Module *Z80Module )
{
    struct ExpDecl *Tmp = Z80Module -> ExpDecl;

    int Len = 0;

    while ( Tmp )
    {
        Len += 4 + strlen( Tmp -> Name ) + 1;
        Tmp = Tmp -> Next;
    }

    return Len;
}


int ExistNameDecl( struct Z80Module *Z80Module, char *Name )
{
    struct NameDecl *Tmp = Z80Module -> NameDecl;

    while ( Tmp )
    {
        if ( strcmp( Tmp -> Name, Name ) == 0 ) return 1;
        Tmp = Tmp -> Next;
    }

    return 0;
}


void AddNameDecl( struct Z80Module *Z80Module, char *Name )
{
    struct NameDecl *Tmp = Z80Module -> NameDecl;
    struct NameDecl *New;

    if ( ExistNameDecl( Z80Module, Name ) ) return;

    New = malloc( sizeof( struct NameDecl ) );

    strcpy( New -> Name, Name );
    New -> Next = 0;

    if ( !Tmp )
    {
        Z80Module -> NameDecl = New;
        return;
    }

    while ( Tmp -> Next ) Tmp = Tmp -> Next;

    Tmp -> Next = New;
}


int GetNameDeclLen( struct Z80Module *Z80Module )
{
    struct NameDecl *Tmp = Z80Module -> NameDecl;

    int Len = 0;

    while ( Tmp )
    {
        Len += 7 + strlen( Tmp -> Name );
        Tmp = Tmp -> Next;
    }

    return Len;
}


int ExistLibNameDecl( struct Z80Module *Z80Module, char *Name )
{
    struct LibNameDecl *Tmp = Z80Module -> LibNameDecl;

    while ( Tmp )
    {
        if ( strcmp( Tmp -> Name, Name ) == 0 ) return 1;
        Tmp = Tmp -> Next;
    }

    return 0;
}


void AddLibNameDecl( struct Z80Module *Z80Module, char *Name )
{
    struct LibNameDecl *Tmp = Z80Module -> LibNameDecl;
    struct LibNameDecl *New;

    if ( ExistLibNameDecl( Z80Module, Name ) ) return;

    New = malloc( sizeof( struct LibNameDecl ) );

    strcpy( New -> Name, Name );
    New -> Next = 0;

    if ( !Tmp )
    {
        Z80Module -> LibNameDecl = New;
        return;
    }

    while ( Tmp -> Next ) Tmp = Tmp -> Next;

    Tmp -> Next = New;
}


int GetLibNameDeclLen( struct Z80Module *Z80Module )
{
    struct LibNameDecl *Tmp = Z80Module -> LibNameDecl;

    int Len = 0;

    while ( Tmp )
    {
        Len += 1 + strlen( Tmp -> Name );
        Tmp = Tmp -> Next;
    }

    return Len;
}


void WriteWord( FILE *Z80File, int Value )
{
    fprintf( Z80File, "%c%c", Value & 255, Value >> 8 );
}


void WriteLong( FILE *Z80File, int Value )
{
    fprintf( Z80File, "%c%c%c%c", Value & 255, Value >> 8, Value >> 16, Value >> 24 );
}


void WriteZ80( struct Z80Module *Z80Module )
{
    FILE *Z80File;

    char Filename[ 12 ];

    struct ExpDecl *TmpExp = Z80Module -> ExpDecl;
    struct NameDecl *TmpName = Z80Module -> NameDecl;
    struct LibNameDecl *TmpLib = Z80Module -> LibNameDecl;

    int i;

    strcpy( Filename, Z80Module -> ModuleName );
    strcat( Filename, ".O" );

    Z80File = fopen( Filename, "wb" );

    fprintf( Z80File, "Z80RMF01" );

    WriteWord( Z80File, Z80Module -> OrgAddress );
    WriteLong( Z80File, Z80Module -> ModuleNamePtr );
    WriteLong( Z80File, Z80Module -> ExpDeclPtr );
    WriteLong( Z80File, Z80Module -> NameDeclPtr );
    WriteLong( Z80File, Z80Module -> LibNameDeclPtr );
    WriteLong( Z80File, Z80Module -> DataBlockPtr );

    while ( TmpExp )
    {
        fprintf( Z80File, "C" );
        WriteWord( Z80File, TmpExp -> Address );
        fprintf( Z80File, "%c%s%c", strlen( TmpExp -> Name ), TmpExp -> Name, 0 );
        TmpExp = TmpExp -> Next;
    }

    fprintf( Z80File, "XA" );
    WriteLong( Z80File, 0 );
    fprintf( Z80File, "%c%s", strlen( Z80Module -> ModuleName ), Z80Module -> ModuleName );

    while ( TmpName )
    {
        fprintf( Z80File, "GA" );
        WriteLong( Z80File, 0 );
        fprintf( Z80File, "%c%s", strlen( TmpName -> Name ), TmpName -> Name );
        TmpName = TmpName -> Next;
    }

    while ( TmpLib )
    {
        fprintf( Z80File, "%c%s", strlen( TmpLib -> Name ), TmpLib -> Name );
        TmpLib = TmpLib -> Next;
    }

    fprintf( Z80File, "%c%s", strlen( Z80Module -> ModuleName ), Z80Module -> ModuleName );

    WriteWord( Z80File, Z80Module -> DataBlockSize );

    for ( i = 0; i < Z80Module -> DataBlockSize; ++i )
        fprintf( Z80File, "%c", Z80Module -> DataBlock[ i ] );

    fclose( Z80File );
}


void ReleaseZ80Module( struct Z80Module *Z80Module )
{
    struct ExpDecl *TmpExp = Z80Module -> ExpDecl;
    struct NameDecl *TmpName = Z80Module -> NameDecl;
    struct LibNameDecl *TmpLib = Z80Module -> LibNameDecl;

    while ( TmpExp )
    {
        TmpExp = Z80Module -> ExpDecl -> Next;
        free( Z80Module -> ExpDecl );
        Z80Module -> ExpDecl = TmpExp;
    }

    while ( TmpName )
    {
        TmpName = Z80Module -> NameDecl -> Next;
        free( Z80Module -> NameDecl );
        Z80Module -> NameDecl = TmpName;
    }

    while ( TmpLib )
    {
        TmpLib = Z80Module -> LibNameDecl -> Next;
        free( Z80Module -> LibNameDecl );
        Z80Module -> LibNameDecl = TmpLib;
    }
}


int ReadOneBit( FILE *FilePtr, int Boundary )
{
    static int Byte = 0;
    static int CurrBit = -1;

    int Bit;

    if ( CurrBit == -1 || Boundary )
    {
        Byte = fgetc( FilePtr );
        CurrBit = 7;
        if ( Boundary ) return 0;
    }

    Bit = ( Byte & 128 ) == 128;

    Byte *= 2;

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


int ReadLink( FILE *FilePtr, int *Location, struct Z80Module *Z80Module )
{
    char Name[ 256 ];

    char Type[ 3 ];

    int Address;

    switch ( ReadBits( FilePtr, 4 ) )
    {
        case 0:
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

//            printf( "Entry symbol: %s\n", Name );

            break;
        case 1:
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

//            printf( "Select common block: %s\n", Name );

            break;
        case 2:
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

//            printf( "Program name: %s\n", Name );

            break;
        case 3:
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

            printf( "Warning: ignoring special item declaration 0011 [%s]\n", Name );

            break;
        case 4:
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

            printf( "Warning: ignoring special item declaration 0100 [%s]\n", Name );

            break;
        case 5:
            AddressType( Type, ReadBits( FilePtr, 2 ) );
            Address = ReadBits( FilePtr, 16 );
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

//            printf( "Common block size: %s %d [%s]\n", Name, Address, Type );

            break;
        case 6:
            AddressType( Type, ReadBits( FilePtr, 2 ) );
            Address = ReadBits( FilePtr, 16 );
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

//            printf( "Chain external: %s %d [%s]\n", Name, Address, Type );

            if ( strcmp( Type, "PR" ) == 0 )
            {
                AddExpDecl( Z80Module, Address, Name );
                AddLibNameDecl( Z80Module, Name );
            }

            break;
        case 7:
            AddressType( Type, ReadBits( FilePtr, 2 ) );
            Address = ReadBits( FilePtr, 16 );
            ReadStr( FilePtr, Name, ReadBits( FilePtr, 3 ) );

//            printf( "Entry point: %s %d [%s]\n", Name, Address, Type );

            if ( *Z80Module -> ModuleName == 0 )
            {
                strcpy( Z80Module -> ModuleName, Name );
                Z80Module -> OrgAddress = Address;
            }
            else
                AddNameDecl( Z80Module, Name );

            break;
        case 8:
            printf( "Error: unused special item 1000\n" );

            exit( 1 );

            break;
        case 9:
            AddressType( Type, ReadBits( FilePtr, 2 ) );
            Address = ReadBits( FilePtr, 16 );

//            printf( "External offset: %d [%s]\n", Address, Type );

            break;
        case 10:
            AddressType( Type, ReadBits( FilePtr, 2 ) );
            Address = ReadBits( FilePtr, 16 );

//            printf( "Data size: %d [%s]\n", Address, Type );

            Z80Module -> DataSize = Address;

            break;
        case 11:
            AddressType( Type, ReadBits( FilePtr, 2 ) );
            Address = ReadBits( FilePtr, 16 );

//            printf( "Location counter: %d [%s]\n", Address, Type );

            *Location = Address;

            break;
        case 12:
            AddressType( Type, ReadBits( FilePtr, 2 ) );
            Address = ReadBits( FilePtr, 16 );

//            printf( "Chain address: %d [%s]\n", Address, Type );

            break;
        case 13:
            AddressType( Type, ReadBits( FilePtr, 2 ) );
            Address = ReadBits( FilePtr, 16 );

//            printf( "Program size: %d [%s]\n", Address, Type );

            break;
        case 14:
            AddressType( Type, ReadBits( FilePtr, 2 ) );
            Address = ReadBits( FilePtr, 16 );

//            printf( "End module: %d [%s]\n\n", Address, Type );

            ReadOneBit( FilePtr, 1 );

            Z80Module -> DataBlockSize = *Location;

            if ( Z80Module -> OrgAddress == 0 )
                Z80Module -> OrgAddress = 65535;

            CompleteExpDecl( Z80Module );

            if ( GetExpDeclLen( Z80Module ) > 0 )
                Z80Module -> ExpDeclPtr = 30;
            else
                Z80Module -> NameDeclPtr = 30;

            if ( Z80Module -> ExpDeclPtr > 0 )
                Z80Module -> NameDeclPtr = Z80Module -> ExpDeclPtr + GetExpDeclLen( Z80Module );

            if ( GetLibNameDeclLen( Z80Module ) > 0 )
                Z80Module -> LibNameDeclPtr = Z80Module -> NameDeclPtr + 7 + strlen( Z80Module -> ModuleName ) + GetNameDeclLen( Z80Module );
            else
                Z80Module -> ModuleNamePtr = Z80Module -> NameDeclPtr + 7 + strlen( Z80Module -> ModuleName ) + GetNameDeclLen( Z80Module );

            if ( Z80Module -> LibNameDeclPtr > 0 )
                Z80Module -> ModuleNamePtr = Z80Module -> LibNameDeclPtr + GetLibNameDeclLen( Z80Module );

            Z80Module -> DataBlockPtr = Z80Module -> ModuleNamePtr + 1 + strlen( Z80Module -> ModuleName );

            WriteZ80( Z80Module );

            memset( Z80Module, 0, sizeof( struct Z80Module ) );

            Z80Module -> ModuleNamePtr  = -1;
            Z80Module -> ExpDeclPtr     = -1;
            Z80Module -> NameDeclPtr    = -1;
            Z80Module -> LibNameDeclPtr = -1;
            Z80Module -> DataBlockPtr   = -1;

            break;
        case 15:
            printf( "End file\n" );

            return 0;

            break;
    }

    return 1;
}


int ReadItem( FILE *FilePtr, struct Z80Module *Z80Module )
{
    static int Location = 0;

    if ( ReadBits( FilePtr, 1 ) == 0 )
    {
//        printf( "%5d [LC] %d\n", Location++, ReadBits( FilePtr, 8 ) );

        Z80Module -> DataBlock[ Location++ ] = ReadBits( FilePtr, 8 );
    }
    else
    {
        switch ( ReadBits( FilePtr, 2 ) )
        {
            case 0:
                return ReadLink( FilePtr, &Location, Z80Module );
            case 1:
//                printf( "%5d [PS] %d\n\n", Location, ReadBits( FilePtr, 16 ) );

                Z80Module -> DataBlock[ Location ] = ReadBits( FilePtr, 8 );
                Z80Module -> DataBlock[ Location + 1 ] = ReadBits( FilePtr, 8 );

                break;
            case 2:
//                printf( "%5d [DS] %d\n\n", Location, ReadBits( FilePtr, 16 ) );

                ReadBits( FilePtr, 16 );

                break;
            case 3:
//                printf( "%5d [CB] %d\n\n", Location, ReadBits( FilePtr, 16 ) );

                ReadBits( FilePtr, 16 );

                break;
        }

        Location += 2;
    }

    return 1;
}


int main( int argc, char *argv[] )
{
    FILE *RelFile;

    struct Z80Module Z80Module;

    if ( argc != 2 )
    {
        printf( "Usage: REL2Z80 <rel obj file name>\n" );
        return 1;
    }

    RelFile = fopen( argv[ 1 ], "rb" );

    if ( !RelFile )
    {
        printf( "Can't open file %s\n", argv[ 1 ] );
        return 1;
    }

    memset( &Z80Module, 0, sizeof( struct Z80Module ) );

    Z80Module.ModuleNamePtr  = -1;
    Z80Module.ExpDeclPtr     = -1;
    Z80Module.NameDeclPtr    = -1;
    Z80Module.LibNameDeclPtr = -1;
    Z80Module.DataBlockPtr   = -1;

    while ( ReadItem( RelFile, &Z80Module ) );

    ReleaseZ80Module( &Z80Module );

    fclose( RelFile );

    return 0;
}