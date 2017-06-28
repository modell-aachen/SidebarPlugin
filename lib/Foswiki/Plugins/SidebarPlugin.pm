# See bottom of file for default license and copyright information
package Foswiki::Plugins::SidebarPlugin;

use strict;
use warnings;

use Foswiki::Func;
use Foswiki::Plugins;
use Foswiki::Plugins::VueJSPlugin;

our $VERSION = '1.0.0';
our $RELEASE = '1.0.0';
our $SHORTDESCRIPTION = 'Sidebar Framework for Q.wiki';
our $NO_PREFS_IN_TOPIC = 1;

sub initPlugin {
  my ($topic, $web, $user, $installWeb) = @_;
  if ($Foswiki::Plugins::VERSION < 2.0) {
    Foswiki::Func::writeWarning( 'Version mismatch between ',
    __PACKAGE__, ' and Plugins.pm' );
    return 0;
  }

  my $session = $Foswiki::Plugins::SESSION;
  my %vueopts = (VERSION => 2);
  Foswiki::Plugins::VueJSPlugin::loadDependencies($session, \%vueopts);

  _addToZone();
  return 1;
}

sub _addToZone {
  Foswiki::Func::addToZone( 'script', 'FOUNDATION',
    "<script type='text/javascript' src='%PUBURL%/%SYSTEMWEB%/FlatSkin/js/foundation.min.js'></script>");
  my $script = <<SCRIPT;
<script type="text/javascript" src="%PUBURLPATH%/%SYSTEMWEB%/SidebarPlugin/sidebar.js"></script>
SCRIPT
  Foswiki::Func::addToZone(
    'script',
    'SIDEBARPLUGIN::SCRIPTS',
    $script,
    'JQUERYPLUGIN::FOSWIKI::PREFERENCES,VUEJSPLUGIN,FOUNDATION'
  );
  my $fa = <<FONT;
<link rel="stylesheet" type="text/css" media="all" href="%PUBURLPATH%/%SYSTEMWEB%/FontAwesomeContrib/css/font-awesome.min.css" />
FONT
  Foswiki::Func::addToZone('head', 'FONTAWESOME', $fa);

  my $skin = <<SKIN;
<link rel="stylesheet" type="text/css" media="all" href="%PUBURLPATH%/%SYSTEMWEB%/FlatSkin/css/flatskin_wrapped.min.css" />
SKIN
  Foswiki::Func::addToZone('head', 'FLATSKIN_WRAPPED', $skin);
}

1;

__END__
Q.Wiki SidebarPlugin - Modell Aachen GmbH

Author: %$AUTHOR%

Copyright (C) 2017 Modell Aachen GmbH

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version. For
more details read LICENSE in the root of this distribution.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

As per the GPL, removal of this notice is prohibited.
