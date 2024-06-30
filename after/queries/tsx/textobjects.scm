; extends
(jsx_element 
  open_tag: (_)
  .
  _ @_start @_end
  _? @_end
  .
  close_tag: (_)
  (#make-range! "jsxtag.inner" @_start @_end)
  ) @jsxtag.outer
