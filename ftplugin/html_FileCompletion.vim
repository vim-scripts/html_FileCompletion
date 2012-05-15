" html_FileCompletion.vim: Base dir- and URL-aware file completion for HTML links.
"
" DEPENDENCIES:
"   - ft/html/FileCompletion.vim autoload script
"
" Copyright: (C) 2012 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.001	09-May-2012	file creation

inoremap <buffer> <script> <expr> <Plug>(HtmlFileComplete) ft#html#FileCompletion#Expr()
if ! hasmapto('<Plug>(HtmlFileComplete)', 'i')
    imap <buffer> <C-x><C-f> <Plug>(HtmlFileComplete)
    let b:undo_ftplugin = (exists('b:undo_ftplugin') ? b:undo_ftplugin . '|' : '') . 'iunmap <buffer> <C-x><C-f>'
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
