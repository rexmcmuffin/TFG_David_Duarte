#----------------------------------------------------------------
# project ....: Plantilla para Trabajos Finales de Graduación
# file .......: Makefile
# authors ....: Pablo Alvarado
# organization: Tecnológico de Costa Rica
# creation ...: 14.08.2018
#----------------------------------------------------------------

MAINFILE=main

LATEX=/usr/bin/latex -interaction=batchmode -file-line-error-style
PDFLATEX=pdflatex -interaction=batchmode
BIB=biber
%BIB=bibtex
ECHO=/bin/echo -E


# TeX files
TEXFILES = $(wildcard ./*.tex) $(wildcard ./sty/*.sty)

# images in fig
PNGFILES = $(wildcard fig/*.png)
JPGFILES = $(wildcard fig/*.jpg)
GPFILES = $(wildcard fig/*_.gp)
OCTFILES = $(wildcard fig/*_.m)
FIGFILES = $(wildcard fig/*.fig)
LFIGFILES = $(wildcard fig/*.ltxfig)
TIKZFILES = $(wildcard fig/*.tikz)
PSTFILES = $(wildcard fig/*.pstricks)
SVGFILES = $(wildcard fig/*.svg)

# eps files in fig
EGPFILES = $(patsubst %.gp,%.eps,$(GPFILES))
EOCTFILES = $(patsubst %.m,%.eps,$(OCTFILES))
EFIGFILES = $(patsubst %.fig,%.eps,$(FIGFILES))
ELFIGFILES = $(patsubst %.ltxfig,%.eps,$(LFIGFILES))
EPSTFILES = $(patsubst %.pstricks,%.eps,$(PSTFILES))

# raster images directly to PDF
PPNGFILES = $(patsubst %.png,%.pdf,$(PNGFILES))
PJPGFILES = $(patsubst %.jpg,%.pdf,$(JPGFILES))
PLTXGPFILES = $(patsubst %_ltx.gp,%.pdf,$(LTXGPFILES))
PLTXMFILES = $(patsubst %_ltx.m,%.pdf,$(LTXMFILES))

PTIKZFILES = $(patsubst %.tikz,%.pdf,$(TIKZFILES))
PSVGFILES = $(patsubst %.svg,%.pdf,$(SVGFILES))

# all eps and pdf files in fig
EPSFILES = $(wildcard fig/*[^_].eps) $(EGPFILES) $(EOCTFILES) $(EFIGFILES) $(ELFIGFILES) $(EPSTFILES) $(ETIKZFILES)
PDFFILES = $(patsubst %.eps,%.pdf,$(EPSFILES)) $(PTIKZFILES) $(PPNGFILES) $(PJPGFILES) $(PSVGFILES)

BIBFILES = $(wildcard *.bib)

# implicit rules (pattern rules)

# eps from octave files
#
# This rule converts *_.m to *_.eps files, which usually are
# converted to the pdf by the .pstricks rule
# 
# As for octave 5.2: octave-cli uses an old graphics toolkit whereas
# octave --no-gui uses Qt, which supports more things.  Octave Qt might
# need to be installd
fig/%_.eps : fig/%_.m
	@echo "Generating $@ from $<" ; \
	set -e ; \
	cd fig ; octave --no-gui -q ../$<

# for eps from gnuplot files
fig/%_.eps : fig/%_.gp
	@echo "Generating $@ from $<" ; \
	cd fig ; gnuplot ../$<

# for pdf images from png
# OLD WAY: convert -density 100x100 $< 'eps:-' > $@
fig/%.pdf : fig/%.png
	@echo "Converting $< to $@" ; \
	set -e ; \
	convert $< -quality 80 -background white -alpha remove -alpha off $<.jp2 ; \
	img2pdf -o $@ $<.jp2 ; \
	rm $<.jp2

# for pdf images from jpeg
fig/%.pdf : fig/%.jpg
	@echo "Converting $< to $@" ; \
	set -e ; \
	convert $< -quality 80 -background white -alpha remove -alpha off $<.jp2 ; \
	img2pdf -o $@ $<.jp2 ; \
	rm $<.jp2


# for eps images from fig
# WARNING: fig files may include eps files directly, so, the following trick
#          of changing to fig to go back with each file is done so that fig2dev
#          can find those files.
fig/%.eps : fig/%.fig
	@echo "Converting $< to $@" ; \
	set -e ; \
	cd fig ; fig2dev -L eps ../$< ../$@


#
# for eps images from ltxfig files (fig files with LaTeX code)
# it is assumed that there exists a file with the same basename but extension
# psfrag.  It must contain the LaTeX code to work with a preliminar eps file
# with extension epstmp.
#
# If the file with extension psfrag does not exist, it will be created with
# a default content, which is: \includegraphics{your_file.epstmp}
#
fig/%.eps : fig/%.ltxfig fig/%.psfrag
	@echo "Converting $< to $@" ; \
	set -e ; \
	file=`basename $< .ltxfig` ; \
	cd fig ; fig2dev -L eps -K $$file.ltxfig $$file.epstmp ; \
	if [ ! -f $$file.psfrag ] ; then \
	  $(ECHO) "\includegraphics{$$file.epstmp}" > $$file.psfrag ; \
	fi ; \
	($(ECHO) '\documentclass{article}' ; \
	 $(ECHO) '\usepackage[spanish]{babel}' ; \
	 $(ECHO) '\usepackage[utf8]{inputenc}' ; \
	 $(ECHO) '\usepackage{mathrsfs,amsmath,amssymb,amstext,bm}' ; \
	 $(ECHO) '\usepackage{graphicx,color,psfrag}' ; \
	 $(ECHO) '\pagestyle{empty}' ; \
	 $(ECHO) '\begin{document} '; \
	 cat $$file.psfrag ; \
	 $(ECHO) '\end{document}')> ../$<.tex ; \
	if ( $(LATEX) ../$<.tex ) ; then \
	  dvips -Ppdf -T 60cm,60cm -o $$file.ps ../$<.dvi ; \
	  ps2eps -l -f $$file.ps ; \
	  rm  -f $$file.ps ../$<.aux ../$<.tex ../$<.log ../$<.dvi ; \
	  rm  -f $$file.epstmp ; \
	else \
	  echo "Error running LaTeX on $<." ; \
	  cat ../$<.log ; \
	  #rm  -f $$file.ps ../$<.aux ../$<.tex ../$<.log ../$<.dvi ; \
	  #rm  -f $$file.epstmp ; \
	fi

#
# pstricks files are a precursor of the now tikz files, except that they
# got through eps first, in order for psfrag to work.
#
# They are mostly used by the *_.gp and *_.m rules, which create figures
# than need some psfrac to embelish the labels.
#
fig/%.eps : fig/%.pstricks
	@echo "Converting $< to $@" ; \
	set -e ; \
	bn=`basename $< .pstricks` ; \
	file=$$bn.pstricks ; \
	cp $< $<.tex ; \
	cd fig ; \
	echo "  Processing $$file.tex" ; \
	if ( $(LATEX) $$file.tex && \
	     dvips -Ppdf -T 60cm,60cm -o $$bn.ps $$file.dvi ) ; then \
	  ps2eps -l -f $$bn.ps ; \
	  rm -f $$file.aux $$file.log $$bn.ps $$file.dvi ; \
	  rm -f $$file.tex ; \
	else \
	  echo "Error running LaTeX on $<.tex" ; \
	  rm -f $$file.aux $$bn.ps $$file.dvi ; \ # $$file.tex ; \
	fi


# Helper target to create template file for a psfrag file on-demand.
fig/%.psfrag:
	set -e ; \
	file=`basename $@ .psfrag` ; \
	if [ ! -f $@ ] ; then \
	  echo "\\includegraphics{$$file.epstmp}" > $@ ; \
	  cp $@ $@.TODO ; \
	fi

# TIKZ
# This is a very generic target.  TIKZ can be any LaTeX code 
fig/%.pdf : fig/%.tikz
	@echo "Converting $< to $@" ; \
	set -e ; \
	bn=`basename $< .tikz` ; \
	file=$$bn.tex ; \
	cp $< fig/$$file ; \
	cd fig ; \
        echo "  Processing $$file" ; \
	if ( $(PDFLATEX) $$file ) ; then \
	  rm -f $$bn.aux $$bn.log ; \
	  rm -f $$file ; \
	else \
	  echo "Error running LaTeX on $$file" ; \
	  rm -f $$bn.aux ; \
	fi

# SVG
fig/%.pdf : fig/%.svg
	@echo "Converting $< to $@" ; \
        echo "  Processing $<" ; \
	if ( rsvg-convert -f pdf -o $@ $< ) ; then \
	  echo "$@ created" ; \
	else \
	  echo "Error converting $< to pdf" ; \
	fi

# for pdf images from eps
fig/%.pdf : fig/%.eps
	@echo "Converting $< to pdf" ; \
	set -e ; \
	epstopdf --outfile=$@ $<


# -----------------------------------------------------------------------------
# Targets
# -----------------------------------------------------------------------------

pdf:     $(MAINFILE).pdf

# Sobre makeindex y xindy: makeindex se usó para hacer el índice, pero no
# maneja bien las tildes en español, así que se sustituyó por xindy.  Sin
# embargo la nomenclatura sigue usando makeindex, porque nomencl no funciona
# con xindy.  Eventualmente se puede sustituir por glossaries...  

$(MAINFILE).pdf: $(TEXFILES) $(PDFFILES)  $(BIBFILES)
	@echo "Generating PDF file..."; \
	echo "------------------------------------------" ;\
	echo "Removing index temporary files..." ;\
	rm -f $(MAINFILE).nl? $(MAINFILE).i* *.aux ;\
	echo "Running latex once..." ;\
	$(PDFLATEX) $(MAINFILE) > pdf.log 2>&1 ;\
	if ( $(BIB) $(MAINFILE) >> pdf.log 2>&1 ) ; then \
	  echo " Bibliography ok" ;\
	else \
	  echo " Bibliography failed" ;\
	fi ;\
	if ( makeindex $(MAINFILE).idx >> pdf.log 2>&1 ) ; then \
	  echo " Index ok" ;\
	else \
	  echo " Index failed" ;\
	fi ;\
	if ( makeindex $(MAINFILE).nlo -s nomencl.ist -o $(MAINFILE).nls >> pdf.log 2>&1 ) ; then \
	  echo " List of symbols ok" ;\
	else \
	  echo " List of symbols failed" ;\
	fi ;\
	echo "Running latex twice..." ;\
	$(PDFLATEX) $(MAINFILE) >> pdf.log 2>&1 ;\
	latex_count=5 ; \
	while egrep -s 'Rerun (LaTeX|to get cross-references right)' $(MAINFILE).log && [ $$latex_count -gt 0 ] ;\
	    do \
	      echo "Rerunning latex...." ;\
	      $(PDFLATEX) $(MAINFILE).tex >> pdf.log 2>&1 ;\
	      latex_count=`expr $$latex_count - 1` ;\
	    done ;\
	echo "Ready."

force-pdf: 
	touch $(MAINFILE).tex ;\
	make pdf

figs:	$(EPSFILES)

pdfigs: figs $(PDFFILES)

partial-clean:
	@echo "Cleaning..." ;\
	rm -f *.log *.lot *.toc *.lof *.aux *.dvi *.nlo *.nls *.glo *.gls;\
	rm -f *.idx *.ilg *.ind *.bbl *.blg *.brf *.out *.todo *.flc *.xmp ;\
	rm -f *.run.xml *.bcf

clean:  partial-clean
	@cd fig ;\
	for e in .fig .png .jpg .ltxfig _.eps .svg ; do \
	  for i in `find . -name "*$$e"` ; do \
	    b=`basename $$i $$e`.eps ;\
	    if [ -f $$b ] ; then \
	      rm $$b ;\
	    fi ;\
	    b=`basename $$i $$e`.pdf ;\
	    if [ -f $$b ] ; then \
	      rm $$b ;\
	    fi ;\
	  done ;\
	done ;\
	for i in `find . -name "*.pdf"` ; do \
	  b=`basename $$i .pdf`.eps ;\
	  if [ -f $$b ] ; then \
	    rm $$i ;\
	  fi ;\
	done ;\
	for i in `find . -name "*_.gp"` ; do \
	  b=`basename $$i .gp`.eps ;\
	  if [ -f $$b ] ; then \
	    rm $$b ;\
	  fi ;\
	  b=`basename $$i .gp`.pdf ;\
	  if [ -f $$b ] ; then \
	    rm $$b ;\
	  fi ;\
	done ;\
	echo "Done." ;\
	cd ..

clean-all: clean
	@rm -f `find . -name "*~"` \#* fig/*.aux ;\
	rm -fr *.ps ;\
	rm -fr `find . -name ".xvpics"` \.#* ;\
	rm -fr fig/*fig.bak ;\
	echo "All cleaned up"

help:
	@echo "This Makefile provides following targets: " ;\
	echo " ps:	  generate $(MAINFILE).ps" ;\
	echo " force-ps:  force generation of $(MAINFILE).ps" ;\
	echo " pdf:       generate $(MAINFILE).pdf" ;\
	echo " force-pdf: force generation of $(MAINFILE).pdf" ;\
	echo " figs:      create eps image files from jpg,png,fig,etc." ;\
	echo " pdfigs:    create pdf image files from jpg,png,fig,etc." ;\
	echo " clean:     remove temporary files but keep final ps and pdf" ;\
	echo " clean-all: like clean but remove also final files"
