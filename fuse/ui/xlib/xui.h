/* xui.h: Routines for dealing with the Xlib user interface
   Copyright (c) 2000 Philip Kendall

   $Id$

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

   Author contact information:

   E-mail: pak21-fuse@srcf.ucam.org
   Postal address: 15 Crescent Road, Wokingham, Berks, RG40 2DB, England

*/

#ifndef FUSE_XUI_H
#define FUSE_XUI_H

#ifndef _XLIB_H_
#include <X11/Xlib.h>
#endif

extern Display *display;	/* Which display are we connected to? */
extern int xui_screenNum;	/* Which screen are we using on our
				   X server? */
extern Window xui_mainWindow;	/* Window ID for the main Fuse window */

#endif			/* #ifndef FUSE_XUI_H */
