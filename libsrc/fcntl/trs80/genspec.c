/*
 *	MIOSYS C compatibility functions
 *	Stefano Bodrato - 2019
 *
 *  This function will generate a new file specification from the input file specification,
 *  using the given output partial file specification and a default extension.
 *  The new file specification is written to the character array pointed to by "partspec".
 *
 *  The following rules specify the resulting specification's name, extension, and drive
 *  of the partial filespec expansion:
 *    (1) The expanded specification will contain all fields passed in "partspec";
 *    (2) If the "partspec" name field is omitted, it will be filled with the name field of "inspec";
 *    (3) If the "partspec" extension field is omitted, and "extn" is not a null string, it will be filled with "extn";
 *    (4) If the "partspec" extension field is omitted, and "extn" is a null string, and "inspec" 
 *        contains an extension field, it will be filled with the extension field of "inspec";
 *    (5) If the "partspec" extension field is omitted, and "extn" is a null string, and "inspec" does not contain
 *        an extension field, the expanded specification will not contain an extension field;
 *    (6) If the "partspec" drive field is omitted, it will be filled with the drive field of "inspec", if any.
 *
 *  Return Code:  A pointer to the expanded file specification is returned.
 *
 *  Warnings:  The partial specification string must be stored in a character array of at least dimension 15 
 *             to avoid overextending the allocated string space.
 *             
 *
 *	$Id: genspec.c $
 *
 */

#include <trsdos.h>

#include <ctype.h>
#include <stdio.h>
#include <string.h>


char *genspec( char *inspec, char *partspec, char *extn)
{
	int x,y;
	char name[9];
	char ext[4];
	char drive[3];
	
	name[0]=0;
	ext[0]=0;
	ext[3]=0;
	drive[0]=0;
	drive[2]=0;
	
	x=strchr(inspec,':');
	if (x>0) {
		strncpy(drive,inspec+x,2);
		inspec[x]=0;
	}
	
	x=strchr(partspec,':');
	if (x>0) {
		strncpy(drive,partspec+x,2);
		partspec[x]=0;
	}
	
	strcpy(ext,extn);

	x=strchr(inspec,'/');
	if (x>0) {
		strncpy(ext,inspec+x+1,3);
		inspec[x]=0;
		strcpy(name,inspec);
	}
	
	x=strchr(partspec,'/');
	if (x>0) {
		strncpy(ext,partspec+x+1,3);
		partspec[x]=0;
		strcpy(name,partspec);
	}
	
	sprintf(partspec,"%s/%s%s",name,ext,drive);
	
	return(partspec);
}
