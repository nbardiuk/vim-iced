let s:suite  = themis#suite('iced.nrepl.navigate')
let s:assert = themis#helper('assert')
let s:buf = themis#helper('iced_buffer')
let s:ch = themis#helper('iced_channel')
let s:sel = themis#helper('iced_selector')

function! s:suite.cycle_ns_test() abort
  call s:assert.equals(iced#nrepl#navigate#cycle_ns('foo.bar'), 'foo.bar-test')
  call s:assert.equals(iced#nrepl#navigate#cycle_ns('foo.bar-test'), 'foo.bar')
endfunction

function! s:suite.related_ns_test() abort
  let test = {}
  function! test.relay(msg) abort
    return (a:msg['op'] ==# 'ns-list')
          \ ? {'status': ['done'], 'ns-list': [
          \      'foo.bar-test',
          \      'foo.bar-spec',
          \      'foo.bar.spec',
          \      'foo.bar-dummy',
          \      'foo.bar.baz',
          \      'bar.baz',
          \      'bar.baz-test',
          \      'foo.baz.bar',
          \    ]}
          \ : {'status': ['done']}
  endfunction

  call s:ch.register_test_builder({'status_value': 'open', 'relay': test.relay})
  call s:buf.start_dummy(['(ns foo.bar)', '|'])
  call s:sel.register_test_builder()

  call iced#nrepl#navigate#related_ns()
  let candidates = s:sel.get_last_config()['candidates']
  call sort(candidates)

  call s:assert.equals(candidates, [
        \ 'foo.bar-spec',
        \ 'foo.bar-test',
        \ 'foo.bar.spec',
        \ 'foo.baz.bar',
        \ ])

  call s:buf.stop_dummy()
endfunction
