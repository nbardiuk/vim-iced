let s:save_cpo = &cpoptions
set cpoptions&vim

function! iced#component#format#cljstyle#start(this) abort
  call iced#util#debug('start', 'format cljstyle')

  if !executable('cljstyle')
    call iced#promise#sync(a:this['installer'].install, ['cljstyle'], 30000)
  endif

  let d = deepcopy(a:this.format_native_image)
  let d.command = ['cljstyle', 'pipe']
  return d
endfunction

let &cpoptions = s:save_cpo
unlet s:save_cpo
