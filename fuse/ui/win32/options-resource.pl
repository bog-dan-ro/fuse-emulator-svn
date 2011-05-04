#!/usr/bin/perl -w

# options-resource.pl: generate options dialog boxes
# $Id$

# Copyright (c) 2001-2007 Philip Kendall, Stuart Brady, Marek Januszewski

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# Author contact information:

# E-mail: philip-fuse@shadowmagic.org.uk

use strict;

use Fuse;
use Fuse::Dialog;

die "No data file specified" unless @ARGV;

my @dialogs = Fuse::Dialog::read( shift @ARGV );

print Fuse::GPL( 'options.rc: options dialog boxes',
		 '2001-2007 Philip Kendall, Stuart Brady' ) . << "CODE";

/* This file is autogenerated from options.dat by options-resource.pl.
   Do not edit unless you know what you\'re doing! */

#include "options_internals.h"
CODE

foreach( @dialogs ) {

    my $buffer = ""; # needed because we find out the height at the end at the end
    my $optname = uc( "OPT_$_->{name}" );
    my $y = 5;
    my $y_label = $y;

    foreach my $widget ( @{ $_->{widgets} } ) {

	my $text = $widget->{text}; $text =~ s/\((.)\)/&$1/;
	if( $widget->{type} eq "Checkbox" ) {
	    $buffer .= sprintf "  AUTOCHECKBOX \"%s\",IDC_%s_%s,5,$y,160,11\n",
		$text, $optname, uc( $widget->{value}, );
	    $y += 12;
	} elsif( $widget->{type} eq "Entry" ) {
	    $y_label = $y + 2;
	    $buffer .= sprintf "  LTEXT \"%s\",IDC_%s_LABEL_%s,5,$y_label,90,9\n",
		$text, $optname, uc( $widget->{value} );
	    $buffer .= sprintf "  EDITTEXT IDC_%s_%s,100,$y,85,13\n",
		$optname, uc( $widget->{value} );
	    $y += 14;
	} elsif( $widget->{type} eq "Combo" ) {
	    $y_label = $y + 2;
	    $buffer .= sprintf "  LTEXT \"%s\",IDC_%s_LABEL_%s,5,$y_label,90,9\n",
		$text, $optname, uc( $widget->{value} );
	    $buffer .= sprintf "  COMBOBOX IDC_%s_%s,100,$y,85,90,"
	        . "CBS_DROPDOWNLIST | CBS_HASSTRINGS\n",
		$optname, uc( $widget->{value} );
	    $y += 14;
	} else {
	    die "Unknown type '$widget->{type}'";
	}

    }

    $y += 5;

    $buffer .= sprintf "  DEFPUSHBUTTON \"OK\",IDOK,45,$y,50,14\n", $optname;
    $buffer .= sprintf "  PUSHBUTTON \"Cancel\",IDCANCEL,100,$y,50,14\n", $optname;

    $y += 14 + 5; #height of the buttons + 5 margin
   
    print << "CODE";

IDD_$optname DIALOGEX 6,5,190,$y
  CAPTION "Fuse - $_->{title}"
  FONT 8,"Ms Shell Dlg 2",400,0,1
  STYLE WS_POPUP | WS_CAPTION | WS_BORDER | WS_SYSMENU
  EXSTYLE WS_EX_APPWINDOW
BEGIN
CODE

    print $buffer;

    print "END\n";
    printf "\n";
}
