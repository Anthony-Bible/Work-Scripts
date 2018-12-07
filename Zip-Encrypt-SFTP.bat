@echo off

REM ##########################################################################################################
REM tO MAKE THIS MODULAR USE PARMAETERS PASSED
REM 1st Parmeter is a path to the folder.
REM This will also keep looping until it is given a path
REM TODO: Verify that it is a valid path
REM ##########################################################################################################

set preworkingDirectory=%1
IF %preworkingDirectory%.==. GOTO No1

GOTO End1

:No1
  echo #############################################
echo ERROR: You didn't input a PARMAETER
echo #############################################
set /p preworkingDirectory="Please enter the full path to the zip files"
GOTO End1


:End1
IF %preworkingDirectory%.==. GOTO No1

set workingDirectory=%preworkingDirectory%
cd %workingDirectory%
REM ##############TODO: LOOK AT verifying all programs neccessary are installed##############################

REM ##########################################################################################################
REM Set the path to pscp so you don't have to redownload it
REM This also makes the script much more portable
REM ##########################################################################################################

set path=%path%;F:\programs\pscp;F:\programs\7-zip
REM ##########################################################################################################
REM ##########################################################################################################
Rem Uses powershell to get the time
REM We use powershell since it is the easiest and cleanest way to get the time stamp
REM Unfortunately for some reason batch doesn't allow you to store commands in variables intuitively
REM Format is YYYYMMDD_hhmmss
REM ##########################################################################################################
REM ##########################################################################################################



set command="powershell -command Get-date -UFormat "%%Y%%m%%d_%%I%%M%%S" "

FOR /F "tokens=*" %%j IN (' %command% ') DO SET X=%%j
echo %X%
REM ##########################################################################################################
REM Set variables so it's easier to use the names later
REM ##########################################################################################################

set name1sZipname=name1_Name2_%X%.zip
set Name2ZipName=Name2_%X%.zip
set Name3ZipName=Name3_%X%.zip
set Name4ZipName=Name4_%X%.zip


REM ##########################################################################################################
REM CREATING ZIPS NOW
REM Other options can be found by running 7z /?
REM COMMAND FORMAT 7z a Destination.zip 
7z a %name1sZipname% name1__Letter*.ftp
7z a %Name2ZipName% Letter*.jpg
7z a %Name3ZipName% Letter-Info*.txt
7z a %Name4ZipName% Name4_Letter*.jpg





REM ##########################################################################################################
REM Encrypt all zip folders with GPG4Win
REM This can be installed from the F:\programs\gpg folder
REM Each recipeint can unlock it because of this we won't gpg the Name4 zip
REM FOr more specifics look at the latest Contract/Interface Agreement
REM If it asks for you to double check the keys, you will want to certify the public key in Kleopatra
REM ##########################################################################################################

REM ##########################################################################################################
REM The two redacted and letter info go directly to client1 so we can encrypt as pgp as requested by client1
REM ##########################################################################################################



gpg --recipient "me@exmaple.com" --recipient "name1@example.com" --output "%Name2ZipName%.pgp" --encrypt %Name2ZipName%
gpg --recipient "me@exmaple.com" --recipient "name1@example.com" --output "%Name3ZipName%.pgp" --encrypt %Name3ZipName%



REM ##########################################################################################################
REM  To decrease liabilty and increase security we will only encrypt for client2
REM Also note that these are encrypted as gpg per specs requested by client2
REM ##########################################################################################################

gpg --recipient "me@example.com" --recipient "name2@example.com" --output "%name1sZipname%.gpg" --encrypt %name1sZipname%
gpg --recipient "me@example.com" --recipient "name2@example.com" --output "%Name4ZipName%.gpg" --encrypt %Name4ZipName%


REM ##########################################################################################################
REM To help organize the files we will create two folders for the different uploads
REM This will also help in speeding up the uplaods too because we don't have to login and log out for each file
REM ##########################################################################################################
mkdir Uploads-folder1_%x%
mkdir Uploads-folder2_%X%
copy /Y %Name2ZipName%.pgp  Uploads-folder1_%X%
copy /Y %Name3ZipName%.pgp  Uploads-folder1_%X%

COPY /Y %name1sZipname%.gpg Uploads-folder2_%X%
copy /Y %Name4ZipName%.gpg Uploads-folder2_%X%



msg %username% did you fix the sftp credentials?
REM ##########################################################################################################
REM We will upload to the production site using putty scp. 
REM This will be the final step in our process
REM ##########################################################################################################


pscp.exe -sftp -P 22 -l Username -pw password Uploads-folder1_%x%\*  ftp.example.com:/
pscp.exe -sftp -P 22 -l Username -pw password Uploads-folder2_%X%\* ftp.example.com:/










