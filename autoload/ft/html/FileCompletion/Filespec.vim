" ft/html/FileCompletion/Filespec.vim: Canonicalize filespecs.
"
" DEPENDENCIES:
"
" Copyright: (C) 2012-2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.12.001	16-May-2012	file creation

function! ft#html#FileCompletion#Filespec#Canonicalize( filespec )
    return substitute(a:filespec, '\\', '/', 'g') . (isdirectory(a:filespec) && a:filespec !~# '[/\\]$' ? '/' : '')
endfunction

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
