nunmap <buffer> j
nunmap <buffer> k
nnoremap j <C-E>
nnoremap k <C-Y>
nnoremap J j
nnoremap K k

nunmap <buffer> gO
nnoremap <buffer> <silent> gO :call man#show_toc()<CR><C-w>L:vertical res 45<CR><C-w>h
nnoremap <buffer> Q <C-w>b:q<CR>
