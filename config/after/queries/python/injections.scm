; extends

; Regex highlight
(string
  (string_start) @_ss
  (string_content) @injection.content
(#match? @_ss "[^rR]?[rR][^rR]?[\"']")
(#set! injection.language "regex"))
