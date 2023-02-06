PROGRAM = bin/designtheme
THEME = greenscreen-theme.txt
$(THEME): $(PROGRAM) Makefile lib/Term/Theme/*.pm lib/Term/Theme/*/*.pm 
	$(PROGRAM) \
		--foreground=1/3,1,0.5 \
		--background=1/3,1,0.075 \
		--no-gamma \
	>$@.tmp
	mv $@.tmp $@
settheme: $(THEME)
	bin/settheme < $(THEME)
	colors

clean:
	@ /bin/rm *.tmp $(THEME) 2>/dev/null || true
