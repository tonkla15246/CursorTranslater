^+t::  ; Ctrl + Shift + T

; Copy text
Clipboard := ""
SendInput, ^c
ClipWait, 1

if ErrorLevel || Clipboard =
{
    MsgBox, Copy failed
    return
}

text := Clipboard

ToolTip, Translating...

; URL encode
encoded := UriEncode(text)

url := "https://translate.googleapis.com/translate_a/single?client=gtx&sl=auto&tl=th&dt=t&q=" . encoded

; Send request
http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
http.Open("GET", url, false)
http.Send()

response := http.ResponseText

ToolTip

; Extract translated text (simple parse)
translated := ""
pos := 1

while RegExMatch(response, "\[\[\[""(.*?)""", match, pos)
{
    translated .= match1
    pos := match.Pos + StrLen(match)
}

if (translated = "")
{
    MsgBox, Translation failed
    return
}

ShowTranslationGui(translated)
return


; ---------------- GUI ----------------
ShowTranslationGui(text) {
    Gui, Translation:Destroy
    Gui, Translation:+AlwaysOnTop +Resize
    Gui, Translation:Font, s11, Segoe UI

    Gui, Translation:Add, Text,, Translation
    Gui, Translation:Add, Edit, w480 h260 ReadOnly -VScroll, %text%
    Gui, Translation:Add, Button, w80 gCloseGui, Close

    Gui, Translation:Show,, Translator
}

CloseGui:
Gui, Translation:Destroy
return


; ---------------- URL ENCODE ----------------
UriEncode(str) {
    VarSetCapacity(out, StrPut(str, "UTF-8"))
    StrPut(str, &out, "UTF-8")

    encoded := ""
    Loop % StrLen(str)
    {
        char := SubStr(str, A_Index, 1)
        if (char ~= "[A-Za-z0-9]")
            encoded .= char
        else if (char = " ")
            encoded .= "%20"
        else {
            hex := Format("{:02X}", Asc(char))
            encoded .= "%" . hex
        }
    }
    return encoded
}