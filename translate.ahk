^+t::  ; Ctrl + Shift + T
Clipboard := ""
Send, ^c
ClipWait, 1
if Clipboard =
    return

RunWait, %ComSpec% /c python translate.py "%Clipboard%", , Hide

; Read UTF-8 file correctly
FileRead, Translated, *P65001 result.txt

MsgBox, 64, Translation, %Translated%
return
