#----------------------------------------------------------------
# Proyecto .: Presentaciones
# Archivo ..: Makefile
# Autores ..: Pablo Alvarado
# Escuela ..: Ingeniería Electrónica, TEC
# Creación .: 25.07.2017
#----------------------------------------------------------------

MAINFILE=presentacion

LATEX=/usr/bin/latex -interaction=batchmode -file-line-error-style
PDFLATEX=pdflatex -interaction=batchmode
BIB=biber
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

# eps files in fig
EGPFILES = $(patsubst %.gp,%.eps,$(GPFILES))
EOCTFILES = $(patsubst %.m,%.eps,$(OCTFILES))
EPNGFILES = $(patsubst %.png,%.eps,$(PNGFILES))
EJPGFILES = $(patsubst %.jpg,%.eps,$(JPGFILES))
EFIGFILES = $(patsubst %.fig,%.eps,$(FIGFILES))
ELFIGFILES = $(patsubst %.ltxfig,%.eps,$(LFIGFILES))
EPSTFILES = $(patsubst %.pstricks,%.eps,$(PSTFILES))

PTIKZFILES = $(patsubst %.tikz,%.pdf,$(TIKZFILES))

# all eps and pdf files in fig
EPSFILES = $(wildcard fig/*.eps) $(EGPFILES) $(EOCTFILES) $(EPNGFILES) $(EJPGFILES) $(EFIGFILES) $(ELFIGFILES) $(EPSTFILES) $(ETIKZFILES)
PDFFILES = $(patsubst %.eps,%.pdf,$(EPSFILES)) $(PTIKZFILES)

# images in img
PNGFILESI = $(wildcard img/*.png)
JPGFILESI = $(wildcard img/*.jpg)
GPFILESI = $(wildcard img/*_.gp)
OCTFILESI = $(wildcard img/*_.m)
FIGFILESI = $(wildcard img/*.fig)
LFIGFILESI = $(wildcard img/*.ltxfig)
TIKZFILESI = $(wildcard img/*.tikz)
PSTFILESI = $(wildcard img/*.pstricks)

# eps files in img
EGPFILESI = $(patsubst %.gp,%.eps,$(GPFILESI))
EOCTFILESI = $(patsubst %.m,%.eps,$(OCTFILESI))
EPNGFILESI = $(patsubst %.png,%.eps,$(PNGFILESI))
EJPGFILESI = $(patsubst %.jpg,%.eps,$(JPGFILESI))
EFIGFILESI = $(patsubst %.fig,%.eps,$(FIGFILESI))
ELFIGFILESI = $(patsubst %.ltxfig,%.eps,$(LFIGFILESI))
EPSTFILESI = $(patsubst %.pstricks,%.eps,$(PSTFILESI))
PTIKZFILESI = $(patsubst %.tikz,%.pdf,$(TIKZFILESI))

# all eps and pdf files in img
EPSFILESI = $(wildcard img/*.eps) $(EGPFILESI) $(EOCTFILESI) $(EPNGFILESI) $(EJPGFILESI) $(EFIGFILESI) $(ELFIGFILESI) $(EPSTFILESI) $(ETIKZFILESI)
PDFFILESI = $(patsubst %.eps,%.pdf,$(EPSFILESI)) $(PTIKZFILESI)

BIBFILES = $(wildcard *.bib)

# implicit rules (pattern rules)

# for eps from octave files
fig/%_.eps : fig/%_.m
	@echo "Generating $@ from $<" ; \
	cd fig ; octave-cli -q ../$<

img/%_.eps : img/%_.m
	@echo "Generating $@ from $<" ; \
	cd img ; octave-cli -q ../$<

# for eps from gnuplot files
fig/%_.eps : fig/%_.gp
	@echo "Generating $@ from $<" ; \
	cd fig ; gnuplot ../$<
img/%_.eps : img/%_.gp
	@echo "Generating $@ from $<" ; \
	cd img ; gnuplot ../$<

# for eps images from png
fig/%.eps : fig/%.png
	@echo "Converting $< to $@" ; \
	convert -density 100x100 $< 'eps:-' > $@

img/%.eps : img/%.png
	@echo "Converting $< to $@" ; \
	convert -density 100x100 $< 'eps:-' > $@

# for eps images from jpeg
fig/%.eps : fig/%.jpg
	@echo "Converting $< to $@" ; \
	jpeg2ps  $< > $@

img/%.eps : img/%.jpg
	@echo "Converting $< to $@" ; \
	jpeg2ps  $< > $@
# for eps images from fig
# WARNING: fig files may include eps files directly, so, the following trick
#          of changing to fig to go back with each file is done so that fig2dev
#          can find those files.
fig/%.eps : fig/%.fig
	@echo "Converting $< to $@" ; \
	cd fig ; fig2dev -L eps ../$< ../$@
img/%.eps : img/%.fig
	@echo "Converting $< to $@" ; \
	cd img ; fig2dev -L eps ../$< ../$@

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
	file=`basename $< .ltxfig` ; \
	cd fig ; fig2dev -L eps -K $$file.ltxfig $$file.epstmp ; \
	if [ ! -f $$file.psfrag ] ; then \
	  $(ECHO) "\includegraphics{$$file.epstmp}" > $$file.psfrag ; \
	fi ; \
	($(ECHO) '\documentclass{article}' ; \
	 $(ECHO) '\usepackage[spanish]{babel}' ; \
	 $(ECHO) '\usepackage[utf8]{inputenc}' ; \
	 $(ECHO) '\usepackage{mathrsfs,amsmath,amssymb,amstext}' ; \
	 $(ECHO) '\usepackage{graphicx,color,psfrag}' ; \
	 $(ECHO) '\pagestyle{empty}' ; \
	 $(ECHO) '\usepackage[scaled]{helvet}' ; \
	 $(ECHO) '\renewcommand\familydefault{\sfdefault}' ; \
	 $(ECHO) '\usepackage[T1]{fontenc}' ; \
	 $(ECHO) '\usepackage{sfmath}' ; \
	 $(ECHO) '\begin{document} '; \
	 $(ECHO) '\sffamily'; \
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

img/%.eps : img/%.ltxfig img/%.psfrag
	@echo "Converting $< to $@" ; \
	file=`basename $< .ltxfig` ; \
	cd img ; fig2dev -L eps -K $$file.ltxfig $$file.epstmp ; \
	if [ ! -f $$file.psfrag ] ; then \
	  $(ECHO) "\includegraphics{$$file.epstmp}" > $$file.psfrag ; \
	fi ; \
	($(ECHO) '\documentclass{article}' ; \
	 $(ECHO) '\usepackage[spanish]{babel}' ; \
	 $(ECHO) '\usepackage[utf8]{inputenc}' ; \
	 $(ECHO) '\usepackage{mathrsfs,amsmath,amssymb,amstext}' ; \
	 $(ECHO) '\usepackage{graphicx,color,psfrag}' ; \
	 $(ECHO) '\pagestyle{empty}' ; \
	 $(ECHO) '\usepackage[scaled]{helvet}' ; \
	 $(ECHO) '\renewcommand\familydefault{\sfdefault}' ; \
	 $(ECHO) '\usepackage[T1]{fontenc}' ; \
	 $(ECHO) '\usepackage{sfmath}' ; \
	 $(ECHO) '\begin{document} '; \
	 $(ECHO) '\sffamily'; \
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
# for eps images from ltxfig files (fig files with LaTeX code)
# it is assumed that there exists a file with the same basename but extension
# psfrag.  It must contain the LaTeX code to work with a preliminar eps file
# with extension epstmp.
#
# If the file with extension psfrag does not exist, it will be created with
# a default content, which is: \includegraphics{your_file.epstmp}
#
fig/%.eps : fig/%.pstricks
	@echo "Converting $< to $@" ; \
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

img/%.eps : img/%.pstricks
	@echo "Converting $< to $@" ; \
	bn=`basename $< .pstricks` ; \
	file=$$bn.pstricks ; \
	cp $< $<.tex ; \
	cd img ; \
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

fig/%.psfrag:
	file=`basename $@ .psfrag` ; \
	if [ ! -f $@ ] ; then \
	  echo "\\includegraphics{$$file.epstmp}" > $@ ; \
	  cp $@ $@.TODO ; \
	fi

img/%.psfrag:
	file=`basename $@ .psfrag` ; \
	if [ ! -f $@ ] ; then \
	  echo "\\includegraphics{$$file.epstmp}" > $@ ; \
	  cp $@ $@.TODO ; \
	fi

# TIKZ
fig/%.pdf : fig/%.tikz
	@echo "Converting $< to $@" ; \
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

# TIKZ
img/%.pdf : img/%.tikz
	@echo "Converting $< to $@" ; \
	bn=`basename $< .tikz` ; \
	file=$$bn.tex ; \
	cp $< img/$$file ; \
	cd img ; \
        echo "  Processing $$file" ; \
	if ( $(PDFLATEX) $$file ) ; then \
	  rm -f $$bn.aux $$bn.log ; \
	  rm -f $$file ; \
	else \
	  echo "Error running LaTeX on $$file" ; \
	  rm -f $$bn.aux ; \
	fi

# for pdf images from eps
fig/%.pdf : fig/%.eps
	@echo "Converting $< to pdf" ; \
	epstopdf --outfile=$@ $<

# for pdf images from eps
img/%.pdf : img/%.eps
	@echo "Converting $< to pdf" ; \
	epstopdf --outfile=$@ $<

pdf: $(MAINFILE).pdf

$(MAINFILE).pdf: $(TEXFILES) $(PDFFILES) $(PDFFILESI)
	echo ======================== ;\
	echo == $(MAINFILE) ;\
	echo ======================== ;\
	rm *.aux ;\
	pdflatex $(MAINFILE).tex ;\
	pdflatex $(MAINFILE).tex

partial-clean:
	@echo "Cleaning..." ;\
	rm -f *.log *.lot *.toc *.lof *.aux *.dvi *.nlo *.nls *.nav *.snm *.glo ;\
	rm -f *.idx *.ilg *.ind *.bbl *.blg *.brf *.out *.todo *.flc *.xmp *.vrb ;\

clean-img:  
	@if [ -d img ]; then \
	  cd img ;\
	  for e in .fig .png .jpg .ltxfig _.eps .tikz .pstricks .psfrag; do \
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
	  cd .. ;\
	fi

clean-fig:  
	@cd fig ;\
	for e in .fig .png .jpg .ltxfig _.eps .tikz .pstricks .psfrag; do \
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

clean: partial-clean 

clean-all: clean clean-img clean-fig
	@rm -f `find . -name "*~"` \#* fig/*.aux ;\
	rm -fr *.ps *.pdf ;\
	rm -fr `find . -name ".xvpics"` \.#* ;\
	rm -fr fig/*fig.bak ;\
	echo "All cleaned up"

figs:	$(EPSFILES) $(PDFFILES) $(EPSFILESI) $(PDFFILESI)

