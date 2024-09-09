#include <ScreenCapture.au3>
#include <WinAPI.au3>
#include <Date.au3>
#include <IE.au3>
#include "..\config\config.au3"

Func CheckOrCreateFolder($folderPath)
    If Not FileExists($folderPath) Then
        DirCreate($folderPath)
        WriteToLog("Folder baru dibuat: " & $folderPath)
    EndIf
EndFunc

Func OpenChrome($path)
	WriteToLog("Opening Chrome browser")
    Local $tipeBrowser = "--incognito"
    	
	; Closes all Chrome instances
	ProcessClose("chrome.exe")
		Sleep(10000)
    
	; Open Chrome Apps
	Run($path & " " & $tipeBrowser)
		Sleep(30000)
	
	; Show Desktop to Make all Applications not Shown in Windows
	ShowDesktop()
		Sleep(5000)
    
	; Click running chrome in taskbar 
	MouseClick("left", $xCoordClickChromeRunTask, $yCoordClickChromeRunTask)
		Sleep(20000)
		
	; Make sure the Chrome window appears in front
    Local $chromeHandle = WinGetHandle("[CLASS:Chrome_WidgetWin_1]")
	_WinAPI_SetForegroundWindow($chromeHandle)
		Sleep(10000)
		
    For $i = 1 To 3
        Send("#{UP}")
			Sleep(2000) ; Add a small delay between each key press
    Next
		Sleep(5000)
    
	; Press Ctrl+0 to set the zoom level to 100%
    Send("^0")
		Sleep(5000)
    
    ; Check the zoom level
    If Not _ZoomLevelIs100Percent() Then
		; If zoom is not equal to 100%, change it to 100%
		_SetZoomLevelTo100Percent()
    EndIf
	
	WriteToLog("Chrome opened successfully")
EndFunc

Func _ZoomLevelIs100Percent()
    ; Get the window title from the browser
    Local $hWnd = WinGetHandle("[CLASS:Chrome_WidgetWin_1]")
    Local $sTitle = WinGetTitle($hWnd)

    ; Get zoom level using regex string
    Local $sZoomLevel = StringRegExpReplace($sTitle, '.*\((\d+)%\).*', '\1')

    ; Check if the zoom level is 100%
    If $sZoomLevel = "100" Then
        Return True
    Else
        Return False
    EndIf
EndFunc

Func _SetZoomLevelTo100Percent()
    ; Press Ctrl+0 to set the zoom level to 100%
    Send("^0")
		Sleep(2000)
EndFunc

Func CloseChrome()
	WriteToLog("Closing Chrome browser")
    Send("^w")
		Sleep(5000)
EndFunc

Func LoginWeb($url, $coordinates, $username, $password)
	WriteToLog("Attempting to login to website : " & $url)
	
	; Click the input column url
    MouseClick("left", $xCoordClickColumnURL, $yCoordClickColumnURL)
		Sleep(8000)
	
	; Ctrl + a
    Send("^a")
	; Input URL
    Send($url)
	; Go to Url page
    Send("{ENTER}")
		Sleep(30000)
	
	; Click Title Tab
    MouseClick("left", $xCoordClickTitleTabWeb, $yCoordClickTitleTabWeb)
		Sleep(10000)
    
    ; Check the zoom level
    If Not _ZoomLevelIs100Percent() Then
		; If zoom is not equal to 100%, change it to 100%
		_SetZoomLevelTo100Percent()
    EndIf

		Sleep(15000)

    ; Check the website privacy error
    If StringInStr(WinGetTitle("[CLASS:Chrome_WidgetWin_1]", ""), "Privacy Error - Google Chrome") Then
		continuePrivacyConnection()
    EndIf
   
    ; Login input Username 
    MouseClick("left", $coordinates[0][0], $coordinates[0][1])
		Sleep(4000) 
    Send("^a")
    Send($username)
        Sleep(4000)
	
	; Login input Password 
    MouseClick("left", $coordinates[1][0], $coordinates[1][1])
		Sleep(4000)
    Send("^a")	
    Send($password)
        Sleep(4000)
	
	; Click button login
    MouseClick("left", $coordinates[2][0], $coordinates[2][1])
		Sleep(30000) 
		
	WriteToLog("Successful attempting to login")
EndFunc

Func LoginWebPrivacyConnect($url, $coordinates, $username, $password)
	WriteToLog("Attempting to login to website : " & $url)
	
	; Click the input column url
    MouseClick("left", $xCoordClickColumnURL, $yCoordClickColumnURL)
		Sleep(2000)
		
	; Ctrl + a
    Send("^a")
	; Input URL
    Send($url)
	; Go to Url page
    Send("{ENTER}")
		Sleep(15000)
    
    ; Check the zoom level
    If Not _ZoomLevelIs100Percent() Then
		; If zoom is not equal to 100%, change it to 100%
		_SetZoomLevelTo100Percent()
    EndIf

		Sleep(8000)
	; Run Func continuePrivacyConnection
	continuePrivacyConnection()
   
   ; Login input Username 
    MouseClick("left", $coordinates[0][0], $coordinates[0][1])
		Sleep(2000) 
    Send("^a")
    Send($username)
        Sleep(2000)
	
	; Login input Password
    MouseClick("left", $coordinates[1][0], $coordinates[1][1])
		Sleep(2000)
    Send("^a")	
    Send($password)
        Sleep(2000)
	
	; Click button login
    MouseClick("left", $coordinates[2][0], $coordinates[2][1])
		Sleep(10000) 
		
	WriteToLog("Successful attempting to login")
EndFunc

Func OpenUrlCapture($url, $path, $name, $iZoomOutClicks, $waitingTime)
	CheckOrCreateFolder($path)
	WriteToLog("Opening URL: " & $url)
    Send("^t")
		Sleep(2000) 
    
    Send("^+{TAB}")
		Sleep(2000) 
    
    Send("^w")
		Sleep(2000)
	
    Send($url)
    Send("{ENTER}")
		Sleep($waitingTime)
	
    ; Check the zoom level
    If Not _ZoomLevelIs100Percent() Then
		; If zoom is not equal to 100%, change it to 100%
		_SetZoomLevelTo100Percent()
    EndIf
	
	; Zoom Out
	For $i = 1 To $iZoomOutClicks
		Send("^-") ; CTRL + tanda minus (zoom out)
			Sleep(2000)
	Next
		
	WriteToLog("Capturing: " & $path & "\" & $name &".png")
	_ScreenCapture_Capture($path & "\" & $name &".png", $xPositionRes, $yPositionRes, $xPositionRes + $widthScreenResolution, $yPositionRes + $heightScreenResolution)
		Sleep(5000) 
	
EndFunc

Func OpenUrlCaptureCustom($url, $path, $name, $iZoomOutClicks, $waitingTime, $xPositionResCustom, $yPositionResCustom, $widthScreenResolutionCustom, $heightScreenResolutionCustom)
	CheckOrCreateFolder($path)
	WriteToLog("Opening URL: " & $url)
    Send("^t")
		Sleep(2000) 
    
    Send("^+{TAB}")
		Sleep(2000) 
    
    Send("^w")
		Sleep(2000)
	
    Send($url)
    Send("{ENTER}")
		Sleep($waitingTime)
	
	; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
			Sleep(2000) 
    EndIf
	
	; Zoom Out
	For $i = 1 To $iZoomOutClicks
		Send("^-") ; CTRL + tanda minus (zoom out)
			Sleep(2000)
	Next
	
	MouseMove(1365, 365)
		Sleep(1000)
		
	WriteToLog("Capturing: " & $path & "\" & $name &".png")
	_ScreenCapture_Capture($path & "\" & $name &".png", $xPositionResCustom, $yPositionResCustom, $xPositionResCustom + $widthScreenResolutionCustom, $yPositionResCustom + $heightScreenResolutionCustom)
		Sleep(5000) 
	
EndFunc

Func OpenUrlCaptureExtraClick($url, $path, $name, $iZoomOutClicks, $aClickPositions, $waitingTime)
	CheckOrCreateFolder($path)
	WriteToLog("Opening URL: " & $url)
    Send("^t")
		Sleep(2000) 
    
    Send("^+{TAB}")
		Sleep(2000) 
    
    Send("^w")
		Sleep(2000)
	
    Send($url)
    Send("{ENTER}")
		Sleep($waitingTime)
	
	; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
			Sleep(2000) 
    EndIf
	
	; Zoom Out
	For $i = 1 To $iZoomOutClicks
		Send("^-") ; CTRL + tanda minus (zoom out)
			Sleep(2000)
	Next
		
	For $i = 0 To UBound($aClickPositions) - 1
		MouseClick("left", $aClickPositions[$i][0], $aClickPositions[$i][1], 1, 0) ; Klik mouse pada posisi yang ditentukan dalam array
			Sleep(5000) ; Tunggu sebelum melakukan klik berikutnya
	Next
			
	WriteToLog("Capturing: " & $path & "\" & $name &".png")
    _ScreenCapture_Capture($path & "\" & $name &".png", $xPositionRes, $yPositionRes, $xPositionRes + $widthScreenResolution, $yPositionRes + $heightScreenResolution)
		Sleep(5000) 
		
EndFunc
	
Func OpenUrlCaptureExtraClickWait($url, $path, $name, $iZoomOutClicks, $aClickPositions, $waitingTime)
	CheckOrCreateFolder($path)
	WriteToLog("Opening URL: " & $url)
    Send("^t")
		Sleep(2000) 
    
    Send("^+{TAB}")
		Sleep(2000) 
    
    Send("^w")
		Sleep(2000)
	
    Send($url)
    Send("{ENTER}")
		Sleep($waitingTime)
	
	; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
			Sleep(2000) 
    EndIf
	
	; Zoom Out
	For $i = 1 To $iZoomOutClicks
		Send("^-") ; CTRL + tanda minus (zoom out)
			Sleep(2000)
	Next
		
	For $i = 0 To UBound($aClickPositions) - 1
		MouseClick("left", $aClickPositions[$i][0], $aClickPositions[$i][1], 1, 0) ; Klik mouse pada posisi yang ditentukan dalam array
			Sleep(5000) ; Tunggu sebelum melakukan klik berikutnya
	Next
		
		Sleep($waitingTime)
	
	WriteToLog("Capturing: " & $path & "\" & $name &".png")
    _ScreenCapture_Capture($path & "\" & $name &".png", $xPositionRes, $yPositionRes, $xPositionRes + $widthScreenResolution, $yPositionRes + $heightScreenResolution)
		Sleep(5000) 
		
	EndFunc
		
Func OpenUrlCaptureExtraClickCustom($url, $path, $name, $iZoomOutClicks, $aClickPositions, $waitingTime, $xPositionResCustom, $yPositionResCustom, $widthScreenResolutionCustom, $heightScreenResolutionCustom)
	CheckOrCreateFolder($path)
	WriteToLog("Opening URL: " & $url)
    Send("^t")
		Sleep(2000) 
    
    Send("^+{TAB}")
		Sleep(2000) 
    
    Send("^w")
		Sleep(2000)
	
    Send($url)
    Send("{ENTER}")
		Sleep($waitingTime)
	
	; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
			Sleep(2000) 
    EndIf
	
	; Zoom Out
	For $i = 1 To $iZoomOutClicks
		Send("^-") ; CTRL + tanda minus (zoom out)
			Sleep(2000)
	Next
		
	For $i = 0 To UBound($aClickPositions) - 1
		MouseClick("left", $aClickPositions[$i][0], $aClickPositions[$i][1], 1, 0) ; Klik mouse pada posisi yang ditentukan dalam array
			Sleep(5000) ; Tunggu sebelum melakukan klik berikutnya
	Next
	
	MouseMove(283, 442)
		Sleep($waitingTime)
	
	WriteToLog("Capturing: " & $path & "\" & $name &".png")
	_ScreenCapture_Capture($path & "\" & $name &".png", $xPositionResCustom, $yPositionResCustom, $xPositionResCustom + $widthScreenResolutionCustom, $yPositionResCustom + $heightScreenResolutionCustom)
		Sleep(5000) 
		
EndFunc	

Func OpenUrlCapturePrivacyConnect($url, $path, $name, $iZoomOutClicks, $waitingTime)
	CheckOrCreateFolder($path)
	WriteToLog("Opening URL: " & $url)
    Send("^t")
		Sleep(2000) 
    
    Send("^+{TAB}")
		Sleep(2000) 
    
    Send("^w")
		Sleep(2000)
	
    Send($url)
    Send("{ENTER}")
		Sleep($waitingTime)
	
	; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
			Sleep(2000) 
    EndIf
	
	continuePrivacyConnection()
		Sleep(3000)
		
	; Zoom Out
	For $i = 1 To $iZoomOutClicks
		Send("^-") ; CTRL + tanda minus (zoom out)
			Sleep(2000)
	Next
		
	WriteToLog("Capturing: " & $path & "\" & $name &".png")
	_ScreenCapture_Capture($path & "\" & $name &".png", $xPositionRes, $yPositionRes, $xPositionRes + $widthScreenResolution, $yPositionRes + $heightScreenResolution)
		Sleep(5000) 
EndFunc

Func continuePrivacyConnection()
	WriteToLog("Continuing privacy connection...")
		Sleep(5000) 
    MouseClick("left", $xCoordClickButtonAdvanced, $yCoordClickButtonAdvanced)
		Sleep(2000) 
    MouseClick("left", $xCoordClickButtonProceed, $yCoordClickButtonProceed)
		Sleep(10000) 
EndFunc

Func SendScreenshotToWhatsApp($groupChatName, $screenshotFolder, $caption)
	WriteToLog("Attempting sending to WhatsApp...")
		Sleep(2000)
    ProcessClose("WhatsApp.exe")
		Sleep(5000)
    
    ; Open WhatsApp using coordinates
    MouseClick("left", $xCoordOpenWhatsapp, $yCoordOpenWhatsapp)
		Sleep(60000)

    ; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
    EndIf

    ; Send Ctrl+F to open the search bar
    Send("^f")
    Send("^a")
		Sleep(15000)
    Send($groupChatName)
		Sleep(15000)

    ; Open group chat
    MouseClick("left", $xCoordOpenChat, $yCoordOpenChat)
		Sleep(15000)

	; Click Column Input Text
    MouseClick("left", $xCoordInputTextWhatsapp, $yCoordInputTextWhatsapp)
		Sleep(15000)
	
	; Insert Caption Greetings
	Send("^a")
    Send($caption)
        Sleep(15000)
	Send("{ENTER}")
	WriteToLog("Insert caption Whatsapp : " & $caption)
		Sleep(15000)
		
    ; Click button attach
    MouseClick("left", $xCoordButtonAttach, $yCoordButtonAttach)
		Sleep(20000)

    ; Click button image
    MouseClick("left", $xCoordButtonImg, $yCoordButtonImg)
		Sleep(40000)

    ; Click path
    MouseClick("left", $xCoordPath, $yCoordPath)
		Sleep(15000)

    ; Enter path location folder
    Send($screenshotFolder)
		Sleep(15000)
    Send("{ENTER}")
		Sleep(30000)

    ; Select all images
    MouseClick("left", $xCoordSelectImg, $yCoordSelectImg)
		Sleep(10000)
    Send("^a")
		Sleep(15000)

    ; Click open for send
    MouseClick("left", $xCoordOpenImg, $yCoordOpenImg)
		Sleep(25000)

    ; Send images
    MouseClick("left", $xCoordSendImg, $yCoordSendImg)
		Sleep(30000)
	WriteToLog("Sending screenshot to WhatsApp...")
EndFunc

Func OpenAppWhatsapp()
	WriteToLog("Attempting to open WhatsApp...")
		Sleep(2000)
    ProcessClose("WhatsApp.exe")
		Sleep(5000)
    
    ; Open WhatsApp using coordinates
    MouseClick("left", $xCoordOpenWhatsapp, $yCoordOpenWhatsapp)
		Sleep(60000)
EndFunc

Func SendCaptureWhatsapp($groupChatName, $screenshotFolder, $caption)
		Sleep(2000)
	MouseClick("left", 637, 371)
		Sleep(20000)
		
	If Not WinActive("WhatsApp") Then
		; Open WhatsApp using coordinates
		MouseClick("left", $xCoordOpenWhatsapp, $yCoordOpenWhatsapp)
			Sleep(60000)
	EndIf
	
    ; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
    EndIf

    ; Send Ctrl+F to open the search bar
    Send("^f")
    Send("^a")
		Sleep(15000)
    Send($groupChatName)
		Sleep(15000)

    ; Open group chat
    MouseClick("left", $xCoordOpenChat, $yCoordOpenChat)
		Sleep(15000)

	; Click Column Input Text
    MouseClick("left", $xCoordInputTextWhatsapp, $yCoordInputTextWhatsapp)
		Sleep(15000)
	
	; Insert Caption Greetings
	Send("^a")
    Send($caption)
        Sleep(15000)
	Send("{ENTER}")
	WriteToLog("Insert caption Whatsapp : " & $caption)
		Sleep(15000)
		
    ; Click button attach
    MouseClick("left", $xCoordButtonAttach, $yCoordButtonAttach)
		Sleep(20000)

    ; Click button image
    MouseClick("left", $xCoordButtonImg, $yCoordButtonImg)
		Sleep(40000)

    ; Click path
    MouseClick("left", $xCoordPath, $yCoordPath)
		Sleep(15000)

    ; Enter path location folder
    Send($screenshotFolder)
		Sleep(15000)
    Send("{ENTER}")
		Sleep(30000)

    ; Select all images
    MouseClick("left", $xCoordSelectImg, $yCoordSelectImg)
		Sleep(10000)
    Send("^a")
		Sleep(15000)

    ; Click open for send
    MouseClick("left", $xCoordOpenImg, $yCoordOpenImg)
		Sleep(25000)

    ; Send images
    MouseClick("left", $xCoordSendImg, $yCoordSendImg)
		Sleep(30000)
	WriteToLog("Sending screenshot to WhatsApp...")
EndFunc
	
Func GetCurrentTime()
    ; Dapatkan tanggal dan waktu saat ini
    Local $year = @YEAR
    Local $month = @MON
    Local $day = @MDAY
    Local $hour = @HOUR
    Local $minute = @MIN

    ; Konversi bulan menjadi nama bulan
    Local $monthName = _DateToMonth($month)

    ; Format waktu dengan menggunakan StringFormat
    Local $formattedTime = StringFormat("%02d %s %d Pukul %02d.%02d WIB", $day, $monthName, $year, $hour, $minute)

    ; Kembalikan waktu yang diformat
    Return $formattedTime
EndFunc
	
Func WriteToLog($message)
    Local $currentTime = @YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC
    Local $logFile = $dirPathLog & "log_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"

    ; Buka file log untuk menambahkan pesan
    Local $file = FileOpen($logFile, 1)
    FileWriteLine($file, "[" & $currentTime & "] " & $message)
    FileClose($file)
EndFunc

Func ShowDesktop()
	; Fungsi untuk menunjukkan desktop
		Sleep(5000)
    Send("#d")
		Sleep(5000)
EndFunc

Func DeleteFolder($folderPath)
    ; Periksa apakah folder ada
    If FileExists($folderPath) Then
        ; Gunakan FileDelete untuk menghapus semua file dalam folder
        FileDelete($folderPath & "\.")
        ; Gunakan DirRemove untuk menghapus folder
        DirRemove($folderPath)
    EndIf
EndFunc

; Function to check connection before continuing
Func CheckInternetConnection()
    Local $pingResult = Ping($IPCheckConn)
    If @error Then
		WriteToLog("No internet connection, process terminated")
        Return False
    Else
		WriteToLog("Internet connection is connected, the process continues")
        Return True
    EndIf
EndFunc

; Function to check color and click correct coordinates
Func CheckAndClickColor($coords)
    Local $color = PixelGetColor($coords[0], $coords[1])
    If Hex($color, 6) = '1DAA61' Then
        MouseClick("left", $coords[0], $coords[1])
        Return True
    EndIf
    Return False
EndFunc

Func ForwardMessage($groupChatNames)
		Sleep(10000)
    ; Right click on the message caption to be selected
    MouseClick("right", $xCoordRightClickCapts, $yCoordRightClickCapts)
		Sleep(10000)
	
    ; Click button select
    MouseClick("left", $xCoordClickBtnSlect, $yCoordClickBtnSlect)
		Sleep(10000)
	
    ; Select pics to forward
    MouseClick("left", $xCoordSlectPicsFwrd, $yCoordSlectPicsFwrd)
		Sleep(10000)
	
    ; Click button forward
    MouseClick("left", $xCoordClickBtnFrwd, $yCoordClickBtnFrwd)
		Sleep(20000)
	
    ; Looping to select each group name to send
    For $i = 0 To UBound($groupChatNames) - 1
		; Click column search
		;MouseClick("left", $xCoordClickClmnSrchFrwd, $yCoordClickClmnSrchFrwd)
		;	Sleep(10000)
        
		; Ctrl + A (select all)
		;Send("^a")
		;	Sleep(10000)
	
		; Input contact name dari array
		Send($groupChatNames[$i])
			Sleep(30000)
    
		; Click grup/contact
		; Tekan Tab
		If $i = 0 Then
			; Iterasi pertama: Tekan Tab satu kali
			Send("{TAB}")
		Else
			; Iterasi berikutnya: Tekan Tab dua kali
			Send("{TAB 2}")
		EndIf
			Sleep(10000)  ; Tunggu sejenak (opsional)
		; Tekan Enter
		Send("{ENTER}")
			Sleep(15000)
    Next
    
	; Check the color and click on the appropriate group/contact
    If Not CheckAndClickColor($CoordClickCntctFrwrdLv1) Then
        If Not CheckAndClickColor($CoordClickCntctFrwrdLv2) Then
            CheckAndClickColor($CoordClickCntctFrwrdLv3)
        EndIf
    EndIf
	
		Sleep(30000)
EndFunc
