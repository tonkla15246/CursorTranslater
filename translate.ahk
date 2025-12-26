^+t::  ; Ctrl + Shift + T
Clipboard := ""
Send, ^c
ClipWait, 1
if Clipboard =
    return

; Run Python translator
RunWait, %ComSpec% /c python translate.py "%Clipboard%", , Hide

; Read UTF-8 result
FileRead, Translated, *P65001 result.txt

ShowTranslationGui(Translated)
return


ShowTranslationGui(text) {
    Gui, Translation:Destroy
    Gui, Translation:+AlwaysOnTop +Resize
    Gui, Translation:Font, s11, Segoe UI
    Gui, Translation:Add, Text,, Translation
    Gui, Translation:Add, Edit, w480 h260 ReadOnly, %text%
    Gui, Translation:Add, Button, w80 gCloseGui, Close
    Gui, Translation:Show,, Translator
}

CloseGui:
Gui, Translation:Destroy
return
