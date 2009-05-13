if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufNewFile,BufRead *.t          setf perltest
    au! BufRead,BufNewFile /tmp/mutt*   setf mail
    au! BufRead,BufNewFile *.CPP        setf cpp
    au! BufRead,BufNewFile *.INI        setf dosini
augroup END
