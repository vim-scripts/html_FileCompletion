" ft/html/FileCompletion.vim: Base dir- and URL-aware file completion for HTML links.
"
" DEPENDENCIES:
"   - escapings.vim autoload script (unless CWD is set to the file's director,
"     or 'autochdir' is set)
"   - subs/URL.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.002	15-May-2012	Need to :chdir to the file's directory to get
"				glob results relative to the file.
"	001	09-May-2012	file creation

function! s:CanonicalizeFilespec( filespec )
    return substitute(a:filespec, '\\', '/', 'g') . (isdirectory(a:filespec) ? '/' : '')
endfunction
function! s:FindFiles( base )
    if expand('%:h') !=# '.'
	" Need to change into the file's directory first to get glob results
	" relative to the file.
	let l:save_cwd = getcwd()
	chdir! %:p:h
    endif
    try
	return map(split(glob(a:base . '*'), "\n"), 's:CanonicalizeFilespec(v:val)')
    finally
	if exists('l:save_cwd')
	    execute 'chdir!' escapings#fnameescape(l:save_cwd)
	endif
    endtry
endfunction
function! s:DetermineBaseDir()
    " TODO: Recurse upward until no *.html found.
endfunction
function! s:FindMatches( base )
    let l:base = a:base
    let l:baseUrl = ''
    if exists('b:baseurl') && ! empty(b:baseurl) && strpart(a:base, 0, len(b:baseurl)) ==# b:baseurl
	let l:baseUrl = b:baseurl
	let l:base = strpart(a:base, len(b:baseurl))
	if empty(l:base)
	    let l:base = '/'
	    let l:baseUrl = substitute(b:baseurl, '/$', '', '')
	endif
    endif

    let l:baseDirspec = ''
    if l:base =~# '^/'
	if ! exists('b:basedir')
	    call s:DetermineBaseDir()
	endif
	if exists('b:basedir')
	    let l:baseDirspec = substitute(substitute(b:basedir, '\\', '/', 'g'), '/$', '', '')
	endif
    endif
"****D echomsg '****' string(l:base)
    let l:decodedBase = subs#URL#Decode(l:base)
    if empty(l:baseDirspec)
	let l:files = s:FindFiles(l:decodedBase)
    else
	let l:files = map(s:FindFiles(l:baseDirspec . l:decodedBase), printf('strpart(v:val, %d)', len(l:baseDirspec)))
    endif

    return map(l:files, '{ "word": l:baseUrl . subs#URL#FilespecEncode(v:val), "abbr": l:baseUrl . v:val }')
endfunction
function! ft#html#FileCompletion#FileComplete( findstart, base )
    if a:findstart
	" Locate the start of the keyword.
	let l:startCol = searchpos('\f*\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    let l:startCol = col('.')
	endif
	return l:startCol - 1 " Return byte index, not column.
    else
	" Find matches starting with a:base.
	return s:FindMatches(a:base)
    endif
endfunction

function! ft#html#FileCompletion#Expr()
    set completefunc=ft#html#FileCompletion#FileComplete
    return "\<C-x>\<C-u>"
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
