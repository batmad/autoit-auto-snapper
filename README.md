# AutoSnapper

AutoSnapper is a suite of AutoIt scripts for automating tasks such as logging into websites, navigating pages, adjusting views, capturing screenshots, managing configurations, and sending images via WhatsApp Desktop. The project is organized into folders for efficient management.

## Project Structure

- **assets/**: Stores the screenshot results.
- **config/**: Contains configuration files for screen resolution, log folder location, and mouse click coordinates for WhatsApp and web login.
- **libs/**: Contains reusable functions such as folder creation, login, opening URLs, taking screenshots, and sending photos via WhatsApp.
- **log/**: Stores logs categorized by date.
- **raw/**: Contains the main script files organized by specific tasks.
- **execution/**: Contains the compiled executable files generated from the scripts in the `raw/` folder.

## Installation

1. Clone the repository to your local machine:
   ```bash
   git clone https://github.com/batmad/autoit-auto-snapper.git
   ```
2. Ensure that AutoIt is installed on your system. If not, download and install it from AutoIt's official website.
3. Configure the necessary files in the config/ folder to match your screen resolution, log folder location, and mouse click coordinates.

## Usage

1. Modify the scripts in the raw/ folder according to the tasks you want to automate.
2. Use the functions provided in the libs/ folder to streamline your scripts.
3. Compile the scripts into executable files using AutoIt's compiler or run them directly if needed.
4. The compiled executables can be found in the exe/ folder, ready to be executed

## Example

Here's a basic example of how to use the login function from the libs/ folder in one of your main scripts:
```
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

```
## Logging
Logs are automatically generated and stored in the log/ folder. The logs are categorized by date, allowing you to track the execution of scripts and any potential issues.

## Contributions
Contributions are welcome! Feel free to fork this repository, make your changes, and submit a pull request.

## Contact
For questions or suggestions, please open an issue in the repository or contact bobyatmadja69@gmail.com.
