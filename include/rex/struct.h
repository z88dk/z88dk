/***************************************************************
 *		struct.h
 *			Header for Rex addin program.
 ***************************************************************/
#ifndef _STRUCT_
#define _STRUCT_


typedef struct
{
	unsigned int 	PointX;
	unsigned int	PointY;
} POINT;


typedef struct {
	unsigned int	x;
	unsigned int	y;
	unsigned int	cx;
	unsigned int	cy;
} RECT;


typedef struct
{
	unsigned int	message;
	unsigned char	bCode;
	unsigned int	sCode;
	POINT		pt;
} MSG;


#endif /* _STRUCT_ */


