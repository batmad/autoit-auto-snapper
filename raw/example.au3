#include "..\libs\libs.au3"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;; Configurasi General ;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Path App Exe Google Chrome
Global $chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;; Configurasi Script ;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Path Folder Screenshot
Global $screenshotFolder = "D:\Project Name\assets\Screenshots\MyProject\"& @YEAR & @MON & @MDAY & "." & @HOUR

; Coordinates Column Login
Global $coordinatesLogin[3][2] = [[1150, 581], [1150, 632], [1150, 682]]
; URL Web to Login
Global $urlLoginWeb = "http://example/login"
; Username & Password to Login Web
Global $usernameLogin = "myuser"
Global $passwordLogin = "mypassword"

; URL to Capture
Global $url = "http://example/dashboard"
; Filename Screenshot 
Global $fileName = "Dashboard Example"
; Click to Zoom Out 
Global $zoomWeb = 4
; Waiting to Screenshot
Global $waitingWeb = 25000;
; Coordinates  Extra Click
Global $coordinatesExtraClick[1][2] = [[703, 155]]

; Destination Whatsapp to Send Capture
Global $destinationWhatsapp = "My Detination Contact"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;; Main Script ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Memeriksa koneksi internet
If Not CheckInternetConnection() Then
    ; Jika tidak ada koneksi, hentikan skrip dan proses AutoIt
    Exit
EndIf

; Open App Google Chrome
OpenChrome($chromePath)

; Doing to Login Web CM093
LoginWeb($urlLoginWeb_2, $coordinatesLogin_2, $usernameLogin_2, $passwordLogin_2)
; Go to Web and do Capture CM093
OpenUrlCaptureExtraClick($url_2, $screenshotFolder, $fileName_2, $zoomWeb_2, $coordinatesExtraClick_2, $waitingWeb_2)

; Close App Google Chrome
CloseChrome()

; Doing Open Whatsapp and Send the Capture
SendScreenshotToWhatsApp($destinationWhatsapp, $screenshotFolder, "Berikut kami lampirkan dashboard example pada " & GetCurrentTime())

; Go to Desktop Without Close Other Application
ShowDesktop()
