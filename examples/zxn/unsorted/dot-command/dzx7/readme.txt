/*
 * (c) Copyright 2015 by Einar Saukas. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * The name of its author may not be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
 
 Modified for the zx-next by z88dk.org
 
 Primary source:
 http://www.worldofspectrum.org/infoseekid.cgi?id=0027996&loadpics=3
 
 Secondary source:
 https://github.com/z88dk/z88dk/tree/master/src/zx7
 
 zx7 requires a 32k buffer to decompress the source file.
 
 The 128k version, which runs when NextZXOS is in its normal mode of operation,
 is a dotn command that allocates this memory from the operating system.  This
 means it will never interfere with basic and it will always be able to run.  It
 also operates on the lfn version of the filename to determine the output
 filename.
 
 The 48k version uses the top 32k of main memory for the buffer.  It requires
 RAMTOP to be below 32768 in order to run and an error message will print
 if that is not the case.  The user is expected to "CLEAR 32767" and then re-try.
 In the future, a new version may save the top 32k to a temporary file and
 restore that on exit so that no RAMTOP check will be necessary.  This will
 be acceptable for dot commands whose running time would dominate disk save/load time.
