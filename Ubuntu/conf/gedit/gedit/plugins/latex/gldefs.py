# -*- coding: utf-8 -*-

import gettext

VERSION = "3.20.0"
PACKAGE = "gedit-latex"
PACKAGE_STRING = "gedit-latex 3.20.0"
GETTEXT_PACKAGE = "gedit-latex"
GL_LOCALEDIR = "/usr/share/locale"

try:
    gettext.bindtextdomain(GETTEXT_PACKAGE, GL_LOCALEDIR)
    _ = lambda s: gettext.dgettext(GETTEXT_PACKAGE, s);
except:
    _ = lambda s: s
