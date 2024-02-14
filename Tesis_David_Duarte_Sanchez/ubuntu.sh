#!/bin/bash

if which lsb_release &> /dev/null
then
    DISTRO=`lsb_release -is`
    RELEASE=`lsb_release -cs`
else
    echo "No particular specification for $DISTRO/$RELEASE"
    exit 1
fi

if [[ "$DISTRO" != "Ubuntu" ]]; then
    echo "  Error: this script is intended for Ubuntu distributions only, and this is '$DISTRO'.";
    exit 1
fi
   

INSTALLER="apt"
if ! which apt &> /dev/null
then
 INSTALLER="apt-get"
fi

if test `whoami` != "root" 
then
  echo "  Error: You need root priviledges to run this script."
  exit $FAILURE
fi

# jpeg2ps deprecated.  Convert using jp2 as proxy to img2pdf
# if [ -f /usr/bin/jpeg2ps ]
# then
#     echo "jpeg2ps is installed."
# else
#     echo "Moving jpeg2ps to the system's path"
#     cp jpeg2ps /usr/bin/jpeg2ps
# fi


# The latest gnuplot is necessary for cool 3D plots, but
# it is not in Ubuntu 20.04 (focal), so we try installing

currentver=`gnuplot -V | sed -e 's/gnuplot \([.0-9]*\) patchlevel \([0-9]*\)/\1.\2/g'`
requiredver="5.4.0"
if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; then 
    echo "GNUPlot version greater than or equal to ${requiredver}.  Ok"
else
    echo "GNUPlot version ${currentver} less than ${requiredver}"

    ## Try to install it.
   

    su - ${SUDO_USER:-$USER} -c ./newgnuplot.sh
 fi

su - ${SUDO_USER:-$USER} -c "pip install pdfCropMargins"
 
# These are the default files for (K)Ubuntu 20.04 LTS
DISTRO=Ubuntu
RELEASE=focal
FILES="texlive-full texlive-lang-all \
       texlive-extra-utils \
       texlive-fonts-recommended \
       texlive-font-utils \
       texlive-formats-extra \
       texlive-plain-generic \
       texlive-lang-spanish \
       texlive-latex-base \
       texlive-latex-extra \
       texlive-latex-recommended \
       texlive-science \
       texlive-pstricks \
       texlive-science \
       texlive-bibtex-extra \
       texlive-publishers \
       texlive-lang-german \
       texlive-lang-spanish \
       texlive-lang-english \
       xfig \
       fig2dev \
       imagemagick \
       ps2eps \
       bibutils \
       texlive-bibtex-extra \
       octave \
       xindy \
       img2pdf \
       librsvg2-bin \
       matlab2tikz"

# Try to find better definitions for the packages used
case "$RELEASE" in
lucid)
    echo "Distributio too old.  Not supported."
    exit 1
    ;;
oneiric)
    echo "Using data for $DISTRO/$RELEASE"
    FILES="texlive texlive-base texlive-base-bin \
           texlive-common texlive-extra-utils \
           texlive-fonts-recommended \
           texlive-font-utils \
           texlive-formats-extra \
           texlive-generic-recommended \
           texlive-lang-spanish \
           texlive-latex-base \
           texlive-latex-extra \
           texlive-latex-recommended \
           texlive-math-extra \
           texlive-plain-extra \
           texlive-pstricks \
           texlive-science \
           texlive-bibtex-extra \
           texlive-publishers \
           xfig \
           transfig \
           imagemagick \
           ps2eps \
           pdftk \
           bibutils \
           biblatex \
           octave3.2"
           ;;
precise)
    echo "Using data for $DISTRO/$RELEASE"
    FILES="texlive texlive-base texlive-base-bin \
           texlive-common texlive-extra-utils \
           texlive-fonts-recommended \
           texlive-font-utils \
           texlive-formats-extra \
           texlive-generic-recommended \
           texlive-lang-spanish \
           texlive-latex-base \
           texlive-latex-extra \
           texlive-latex-recommended \
           texlive-math-extra \
           texlive-plain-extra \
           texlive-pstricks \
           texlive-science \
           texlive-bibtex-extra \
           texlive-publishers \
           xfig \
           transfig \
           imagemagick \
           ps2eps \
           pdftk \
           bibutils \
           biblatex \
           octave3.2"
           ;;
bionic)
    echo "Using data for $DISTRO/$RELEASE"
    FILES="texlive-full texlive-lang-all \
           texlive-extra-utils \
           texlive-fonts-recommended \
           texlive-font-utils \
           texlive-formats-extra \
           texlive-generic-recommended \
           texlive-lang-spanish \
           texlive-latex-base \
           texlive-latex-extra \
           texlive-latex-recommended \
           texlive-science \
           texlive-plain-extra \
           texlive-pstricks \
           texlive-science \
           texlive-bibtex-extra \
           texlive-publishers \
           texlive-lang-german \
           texlive-lang-spanish \
           texlive-lang-english \
           xfig \
           transfig \
           imagemagick \
           ps2eps \
           bibutils \
           texlive-bibtex-extra \
           octave \
           matlab2tikz"
           ;;
focal)
    echo "Using data for $DISTRO/$RELEASE"
    ;;

jammy)
    echo "Using data for $DISTRO/$RELEASE"
    FILES="texlive-full texlive-lang-all \
           texlive-extra-utils \
           texlive-fonts-recommended \
           texlive-font-utils \
           texlive-formats-extra \
           texlive-plain-generic \
           texlive-lang-spanish \
           texlive-latex-base \
           texlive-latex-extra \
           texlive-latex-recommended \
           texlive-science \
           texlive-pstricks \
           texlive-science \
           texlive-bibtex-extra \
           texlive-publishers \
           texlive-lang-german \
           texlive-lang-spanish \
           texlive-lang-english \
           xfig \
           fig2dev \
           imagemagick \
           ps2eps \
           bibutils \
           texlive-bibtex-extra \
           octave \
           xindy \
           img2pdf \
           librsvg2-bin \
           matlab2tikz"
    ;;

*)
    echo "No particular specification for $DISTRO/$RELEASE"
    echo "Using focal data"
    ;;
esac

$INSTALLER install $FILES


