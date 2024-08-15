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
    	
    Run($path & " " & $tipeBrowser)
		Sleep(20000)
    
	; Memastikan jendela Chrome muncul di depan
    Local $chromeHandle = WinGetHandle("[CLASS:Chrome_WidgetWin_1]")
	_WinAPI_SetForegroundWindow($chromeHandle)
		Sleep(5000)
		
    For $i = 1 To 3
        Send("#{UP}")
			Sleep(500) ; Optional: Add a small delay between each key press
    Next
		Sleep(2000)
    
    Send("^0")
		Sleep(2000)
    
    ; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
    EndIf
	
	WriteToLog("Chrome opened successfully")
EndFunc

Func _ZoomLevelIs100Percent()
    ; Dapatkan title window dari browser
    Local $hWnd = WinGetHandle("[CLASS:Chrome_WidgetWin_1]")
    Local $sTitle = WinGetTitle($hWnd)

    ; Dapatkan zoom level menggunakan string regex
    Local $sZoomLevel = StringRegExpReplace($sTitle, '.*\((\d+)%\).*', '\1')

    ; Periksa apakah zoom level adalah 100%
    If $sZoomLevel = "100" Then
        Return True
    Else
        Return False
    EndIf
EndFunc

Func _SetZoomLevelTo100Percent()
    ; Tekan tombol Ctrl+0 untuk mengatur zoom level ke 100%
    Send("^0")
		Sleep(2000)
EndFunc

Func CloseChrome()
	WriteToLog("Closing Chrome browser")
    Send("^w")
		Sleep(2000)
EndFunc

Func LoginWeb($url, $coordinates, $username, $password)
	WriteToLog("Attempting to login to website : " & $url)
	
    MouseClick("left", $xCoordClickColumnURL, $yCoordClickColumnURL)
		Sleep(2000)
    Send("^a")
    Send($url)
    Send("{ENTER}")
		Sleep(10000)
    MouseClick("left", $xCoordClickTitleTabWeb, $yCoordClickTitleTabWeb)
		Sleep(5000)
    
    ; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
    EndIf

		Sleep(10000)

    ; Cek website privacy error
    If StringInStr(WinGetTitle("[CLASS:Chrome_WidgetWin_1]", ""), "Privacy Error - Google Chrome") Then
		continuePrivacyConnection()
    EndIf
   
    MouseClick("left", $coordinates[0][0], $coordinates[0][1])
		Sleep(2000) 
    Send("^a")
    Send($username)
        Sleep(2000)
	
    MouseClick("left", $coordinates[1][0], $coordinates[1][1])
		Sleep(2000)
    Send("^a")	
    Send($password)
        Sleep(2000)
	
    MouseClick("left", $coordinates[2][0], $coordinates[2][1])
		Sleep(15000) 
		
	WriteToLog("Successful attempting to login")
EndFunc

Func LoginWebPrivacyConnect($url, $coordinates, $username, $password)
	WriteToLog("Attempting to login to website : " & $url)
	
    MouseClick("left", $xCoordClickColumnURL, $yCoordClickColumnURL)
		Sleep(2000)
    Send("^a")
    Send($url)
    Send("{ENTER}")
		Sleep(15000)
    
    ; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
    EndIf

		Sleep(8000)
	continuePrivacyConnection()
   
    MouseClick("left", $coordinates[0][0], $coordinates[0][1])
		Sleep(2000) 
    Send("^a")
    Send($username)
        Sleep(2000)
	
    MouseClick("left", $coordinates[1][0], $coordinates[1][1])
		Sleep(2000)
    Send("^a")	
    Send($password)
        Sleep(2000)
	
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
		Sleep(2000)
    
    ; Open WhatsApp using coordinates
    MouseClick("left", $xCoordOpenWhatsapp, $yCoordOpenWhatsapp)
		Sleep(35000)

    ; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
    EndIf

    ; Send Ctrl+F to open the search bar
    Send("^f")
    Send("^a")
		Sleep(10000)
    Send($groupChatName)
		Sleep(10000)

    ; Open group chat
    MouseClick("left", $xCoordOpenChat, $yCoordOpenChat)
		Sleep(12000)

	; Click Column Input Text
    MouseClick("left", $xCoordInputTextWhatsapp, $yCoordInputTextWhatsapp)
		Sleep(10000)
	
	; Insert Caption Greetings
	Send("^a")
    Send($caption)
        Sleep(10000)
	Send("{ENTER}")
	WriteToLog("Insert caption Whatsapp : " & $caption)
		Sleep(10000)
		
    ; Click button attach
    MouseClick("left", $xCoordButtonAttach, $yCoordButtonAttach)
		Sleep(10000)

    ; Click button image
    MouseClick("left", $xCoordButtonImg, $yCoordButtonImg)
		Sleep(25000)

    ; Click path
    MouseClick("left", $xCoordPath, $yCoordPath)
		Sleep(10000)

    ; Enter path location folder
    Send($screenshotFolder)
		Sleep(10000)
    Send("{ENTER}")
		Sleep(12000)

    ; Select all images
    MouseClick("left", $xCoordSelectImg, $yCoordSelectImg)
		Sleep(10000)
    Send("^a")
		Sleep(12000)

    ; Click open for send
    MouseClick("left", $xCoordOpenImg, $yCoordOpenImg)
		Sleep(12000)

    ; Send images
    MouseClick("left", $xCoordSendImg, $yCoordSendImg)
		Sleep(15000)
	WriteToLog("Sending screenshot to WhatsApp...")
EndFunc

Func OpenAppWhatsapp()
	WriteToLog("Attempting to open WhatsApp...")
		Sleep(2000)
    ProcessClose("WhatsApp.exe")
		Sleep(2000)
    
    ; Open WhatsApp using coordinates
    MouseClick("left", $xCoordOpenWhatsapp, $yCoordOpenWhatsapp)
		Sleep(35000)
EndFunc

Func SendCaptureWhatsapp($groupChatName, $screenshotFolder, $caption)
		Sleep(2000)
	MouseClick("left", 637, 371)
		Sleep(5000)
		
	If Not WinActive("WhatsApp") Then
		; Open WhatsApp using coordinates
		MouseClick("left", $xCoordOpenWhatsapp, $yCoordOpenWhatsapp)
			Sleep(35000)
	EndIf
	
    ; Cek zoom level
    If Not _ZoomLevelIs100Percent() Then
		; Jika zoom tidak sama dengan 100%, ubah menjadi 100%
		_SetZoomLevelTo100Percent()
    EndIf

    ; Send Ctrl+F to open the search bar
    Send("^f")
    Send("^a")
		Sleep(10000)
    Send($groupChatName)
		Sleep(10000)

    ; Open group chat
    MouseClick("left", $xCoordOpenChat, $yCoordOpenChat)
		Sleep(12000)

	; Click Column Input Text
    MouseClick("left", $xCoordInputTextWhatsapp, $yCoordInputTextWhatsapp)
		Sleep(10000)
	
	; Insert Caption Greetings
	Send("^a")
    Send($caption)
        Sleep(10000)
	Send("{ENTER}")
	WriteToLog("Insert caption Whatsapp : " & $caption)
		Sleep(10000)
		
    ; Click button attach
    MouseClick("left", $xCoordButtonAttach, $yCoordButtonAttach)
		Sleep(10000)

    ; Click button image
    MouseClick("left", $xCoordButtonImg, $yCoordButtonImg)
		Sleep(25000)

    ; Click path
    MouseClick("left", $xCoordPath, $yCoordPath)
		Sleep(10000)

    ; Enter path location folder
    Send($screenshotFolder)
		Sleep(10000)
    Send("{ENTER}")
		Sleep(12000)

    ; Select all images
    MouseClick("left", $xCoordSelectImg, $yCoordSelectImg)
		Sleep(10000)
    Send("^a")
		Sleep(12000)

    ; Click open for send
    MouseClick("left", $xCoordOpenImg, $yCoordOpenImg)
		Sleep(12000)

    ; Send images
    MouseClick("left", $xCoordSendImg, $yCoordSendImg)
		Sleep(15000)
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

; Fungsi untuk memeriksa koneksi internet
Func CheckInternetConnection()
    Local $pingResult = Ping("google.com")
    If @error Then
		WriteToLog("No internet connection, process terminated")
        Return False
    Else
		WriteToLog("Internet connection is connected, the process continues")
        Return True
    EndIf
EndFunc

;; API Whatsapp Baileys ;;

Func SendMessageAPI($number, $message, $filepath)
    Local $sCmd = 'curl --location "http://localhost:8000/send-message" --form "message=' & $message & '" --form "number=' & $number & '" --form "file_dikirim=@\"' & $filepath & '\""'
	Run(@ComSpec & ' /c ' & $sCmd, '', @SW_HIDE)
EndFunc

Func SendMessageGroupAPI($idGroup, $message, $filepath)
    Local $sCmd = 'curl --location "http://localhost:8000/send-group-message" --form "message=' & $message & '" --form "id_group=' & $idGroup & '" --form "file_dikirim=@\"' & $filepath & '\""'
	Run(@ComSpec & ' /c ' & $sCmd, '', @SW_HIDE)
EndFunc


