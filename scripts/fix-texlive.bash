#!/usr/bin/env bash

# This has to be a "user install" (even though the user is root), and
# wrapfig and capt-of aren't debian-packaged.  So we go through CTAN instead.

export TEXMFHOME=/emacs/texlive
tlmgr init-usertree
tlmgr install wrapfig capt-of
