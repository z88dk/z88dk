#ifndef GAMES_H
#define GAMES_H

/*
 *	Videogames support code
 *
 *	Stefano, Jan 2001
 *
 *	$Id: games.h,v 1.2 2001-04-20 16:04:24 dom Exp $
 *
 */


/* draw a sprite of variable size */
extern __LIB__ bksave(int x, int y, void *sprite);
extern __LIB__ bkrestore(void *sprite);
extern __LIB__ getsprite(int x, int y, void *sprite);
extern __LIB__ putsprite(int ortype, int x, int y, void *sprite);

#define spr_mask 166+47*256 // CPL - AND (HL)
#define spr_and  166+47*256 // CPL - AND (HL)
#define spr_or   182 // OR (HL)
#define spr_xor  174 // XOR (HL)

#endif

