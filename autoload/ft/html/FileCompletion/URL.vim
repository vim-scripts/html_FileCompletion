" ft/html/FileCompletion/URL.vim: Classification of URL types.
"
" DEPENDENCIES:
"   - ingo/os.vim autoload script
"   - ingo/fs/path.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.20.003	23-May-2014	Use ingo#fs#path#Exists() instead of
"				filereadable() to also catch directories.
"   1.20.002	22-May-2014	Also detect absolute filespecs.
"   1.12.001	18-May-2012	file creation

function! ft#html#FileCompletion#URL#GetType( url )
    if (a:url =~# '^[/\\]' || ((ingo#os#IsWinOrDos() || ingo#os#IsCygwin()) && a:url =~? '^\a:[/\\]')) && ingo#fs#path#Exists(a:url)
	return 'filespec'
    elseif a:url =~# '^/'
	return 'abs'
    elseif a:url =~? '^[a-z+.-]\+:' " RFC 1738
	return 'full'
    else
	return 'rel'
    endif
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
