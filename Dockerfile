# Inspired by https://gitlab.com/olberger/docker-org-teaching-export
FROM debian:testing-slim

WORKDIR /tmp
COPY scripts/install-debian-packages.bash /tmp
RUN /tmp/install-debian-packages.bash

# We just generated locales
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

RUN mkdir /emacs
WORKDIR /emacs
ENV HOME=/emacs

COPY scripts/fix-texlive.bash /tmp
RUN /tmp/fix-texlive.bash
ENV TEXMFHOME=/emacs/texlive

COPY scripts/install.el /emacs/install.el
RUN emacs --batch --load /emacs/install.el
RUN emacs --version | head -n 1 > /emacs/emacs-version.log
RUN emacs --batch --eval '(message (org-version))' 2>&1 | \
    tail -n 1 > /emacs/org-mode-version.log
COPY scripts/export.el /emacs/export.el

COPY scripts/startup.sh /startup.sh

RUN rm -rf /tmp/*

ENTRYPOINT ["/startup.sh"]
