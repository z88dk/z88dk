////////////////////////////////////////////////////////////////////////////////
// swap.h                                                                     //
// Endianness swap functions                                                  //
//                                                                            //
// Copyright 2012-     Christian Vogelgsang, A.M. Robinson, Rok Krajnc        //
//                                                                            //
// This file is part of Minimig                                               //
//                                                                            //
// Minimig is free software; you can redistribute it and/or modify            //
// it under the terms of the GNU General Public License as published by       //
// the Free Software Foundation; either version 2 of the License, or          //
// (at your option) any later version.                                        //
//                                                                            //
// Minimig is distributed in the hope that it will be useful,                 //
// but WITHOUT ANY WARRANTY; without even the implied warranty of             //
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the              //
// GNU General Public License for more details.                               //
//                                                                            //
// You should have received a copy of the GNU General Public License          //
// along with this program.  If not, see <http://www.gnu.org/licenses/>.      //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
// Changelog                                                                  //
//                                                                            //
// 2012-08-02 - rok.krajnc@gmail.com                                          //
// Functions are now generic - removed assembler code. Added function-like    //
// macros (gcc specific!).                                                    //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////


#ifndef __SWAP_H__
#define __SWAP_H__

//if big endian:
//#define SWAP

//if big endian and want to use macros:
//#define SWAP_MACROS

#ifdef SWAP

#ifdef SWAP_MACROS
//// macros ////
#define SwapBBBB(x)  ({ typeof(x) _x = (x); ((_x&0x00ff0000)>>8)  | ((_x&0xff000000)>>24) | ((_x&0x000000ff)<<24) | ((_x&0x0000ff00)<<8); })
#define SwapBB(x)    ({ typeof(x) _x = (x); ((_x&0x00ff)<<8)      | ((_x&0xff00)>>8); })
#define SwapWW(x)    ({ typeof(x) _x = (x); ((_x&0x0000ffff)<<16) | ((_x&0xffff0000)>>16); })

#else	// SWAP_MACROS

//// function declarations ////
unsigned long SwapBBBB (unsigned long i);
unsigned int  SwapBB   (unsigned int i);
unsigned long SwapWW   (unsigned long i);

#endif // SWAP_MACROS

#else	// SWAP

#define SwapBBBB(x)  (x)
#define SwapBB(x)    (x)
#define SwapWW(x)    (x)

#endif // SWAP

#endif // __SWAP_H__
