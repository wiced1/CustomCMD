@echo off
title CMD
mode 87, 30
chcp 65001 >nul
for /f %%A in ('"prompt $H &echo on &for %%B in (1) do rem"') do set BS=%%A
:input
echo.
echo  [97m╔══[0m([92m%username%[0m@[95m%computername%[0m)-[[91m%cd%[0m]
set /p cmd=".%BS% [97m╚══>[0m "
echo.

rem Check if the input is 'help'
if /i "%cmd%"=="help" (
    call :show_windows_help
    goto input
)

rem Check if the input is 'helpextra'
if /i "%cmd%"=="helpextra" (
    call :show_extra_help
    goto input
)

rem Check if the input is 'sysinfo'
if /i "%cmd%"=="sysinfo" (
    call :sysinfo
    goto input
)

rem Check if the input is 'settings'
if /i "%cmd%"=="settings" (
    call :settings_menu
    goto input
)

rem Check if the input is 'ps' or 'tasklist' for system processes
if /i "%cmd%"=="ps" (
    tasklist
    goto input
)

rem Check if the input is 'network'
if /i "%cmd%"=="network" (
    ipconfig /all
    netstat -ano
    goto input
)

rem Check if the input is 'env' for environment variables display
if /i "%cmd%"=="env" (
    set
    goto input
)

rem Check if the input starts with 'run ' for batch script execution
if /i "%cmd:~0,4%"=="run " (
    call :execute_batch_script "%cmd:~4%"
    goto input
)

rem Hidden mode (not logging commands to a file)
if /i "%cmd%"=="hiddenmode" (
    call :enter_hidden_mode
    goto input
)

rem Execute the command entered by the user
%cmd%
goto input

:sysinfo
echo [93mSystem Information:[0m
echo [97m====================[0m
echo [93m- Operating System:[0m %OS%
echo [93m- Version:[0m %ver%
echo [93m- Date:[0m %date%
echo [93m- Time:[0m %time%
echo [93m- Memory Status:[0m
for /f "tokens=*" %%M in ('systeminfo ^| findstr /i "Available Physical Memory Total Physical Memory"') do (
    echo %%M
)
echo [97m====================[0m
echo.
exit /b

:settings_menu
echo.
echo [96mSettings Menu[0m
echo [97m====================[0m
echo [94m1.[0m Add custom commands
echo [94m2.[0m Change prompt appearance
echo [94m3.[0m Exit Settings
echo.
set /p choice="Enter choice (1-3): "
echo.
if "%choice%"=="1" (
    call :add_custom_commands
) else if "%choice%"=="2" (
    call :change_prompt_appearance
) else if "%choice%"=="3" (
    exit /b
) else (
    echo [91mInvalid choice. Please enter a number from 1 to 3.[0m
    goto settings_menu
)
exit /b

:add_custom_commands
echo [96mAdding custom commands[0m
echo [97m====================[0m
echo [97mType a command to add or 'exit' to return to settings menu.[0m
set /p custom_cmd="Enter command: "
echo.
if /i "%custom_cmd%"=="exit" (
    exit /b
) else (
    echo Adding '%custom_cmd%' as a custom command.
    echo %custom_cmd% >> custom_commands.txt
    echo.
    echo [92mCustom command added successfully.[0m
    goto add_custom_commands
)
exit /b

:change_prompt_appearance
echo [96mChange Prompt Appearance[0m
echo [97m====================[0m
echo [97mChoose a color scheme:[0m
echo [94m1.[0m Blue
echo [94m2.[0m Green
echo [94m3.[0m Red
echo.
set /p color_choice="Enter color choice (1-3): "
echo.
if "%color_choice%"=="1" (
    set "prompt_color=34"
    echo [92mPrompt color changed to Blue.[0m
) else if "%color_choice%"=="2" (
    set "prompt_color=92"
    echo [92mPrompt color changed to Green.[0m
) else if "%color_choice%"=="3" (
    set "prompt_color=91"
    echo [92mPrompt color changed to Red.[0m
) else (
    echo [91mInvalid choice. Please enter a number from 1 to 3.[0m
    goto change_prompt_appearance
)
echo.
echo Setting prompt color...
echo [%prompt_color%m                     ┌─┐┌─┐┌┬┐┌┬┐┌─┐┌┐┌┌┬┐  ┌─┐┬─┐┌─┐┌┬┐┌─┐┌┬┐[0m
echo [%prompt_color%m                     │  │ │││││││├─┤│││ ││  ├─┘├┬┘│ ││││├─┘ │ [0m
echo [%prompt_color%m                     └─┘└─┘┴ ┴┴ ┴┴ ┴┘└┘─┴┘  ┴  ┴└─└─┘┴ ┴┴   ┴ [0m
echo.
exit /b

:execute_batch_script
rem Example function to execute batch scripts
echo [96mExecuting batch script: %1[0m
echo [97m====================[0m
call %1
echo [97m====================[0m
echo [96mBatch script execution completed.[0m
exit /b

:enter_hidden_mode
echo [96mEntering Hidden Mode[0m
echo [97m====================[0m
echo [97mWARNING: Commands executed in hidden mode will not be logged.[0m
pause
exit /b

:show_windows_help
echo.
echo [96mMicrosoft Windows [Version 10.0.22631.3737][0m
echo [97m(c) Microsoft Corporation. All rights reserved.[0m
echo.
echo [97mC:\Users\User>help[0m
echo [97mFor more information on a specific command, type HELP command-name[0m
echo [97mASSOC          Displays or modifies file extension associations.[0m
echo [97mATTRIB         Displays or changes file attributes.[0m
echo [97mBREAK          Sets or clears extended CTRL+C checking.[0m
echo [97mBCDEDIT        Sets properties in boot database to control boot loading.[0m
echo [97mCACLS          Displays or modifies access control lists (ACLs) of files.[0m
echo [97mCALL           Calls one batch program from another.[0m
echo [97mCD             Displays the name of or changes the current directory.[0m
echo [97mCHCP           Displays or sets the active code page number.[0m
echo [97mCHDIR          Displays the name of or changes the current directory.[0m
echo [97mCHKDSK         Checks a disk and displays a status report.[0m
echo [97mCHKNTFS        Displays or modifies the checking of disk at boot time.[0m
echo [97mCLS            Clears the screen.[0m
echo [97mCMD            Starts a new instance of the Windows command interpreter.[0m
echo [97mCOLOR          Sets the default console foreground and background colors.[0m
echo [97mCOMP           Compares the contents of two files or sets of files.[0m
echo [97mCOMPACT        Displays or alters the compression of files on NTFS partitions.[0m
echo [97mCONVERT        Converts FAT volumes to NTFS.  You cannot convert the[0m
echo [97m               current drive.[0m
echo [97mCOPY           Copies one or more files to another location.[0m
echo [97mDATE           Displays or sets the date.[0m
echo [97mDEL            Deletes one or more files.[0m
echo [97mDIR            Displays a list of files and subdirectories in a directory.[0m
echo [97mDISKPART       Displays or configures Disk Partition properties.[0m
echo [97mDOSKEY         Edits command lines, recalls Windows commands, and[0m
echo [97m               creates macros.[0m
echo [97mDRIVERQUERY    Displays current device driver status and properties.[0m
echo [97mECHO           Displays messages, or turns command echoing on or off.[0m
echo [97mENDLOCAL       Ends localization of environment changes in a batch file.[0m
echo [97mERASE          Deletes one or more files.[0m
echo [97mEXIT           Quits the CMD.EXE program (command interpreter).[0m
echo [97mFC             Compares two files or sets of files, and displays the[0m
echo [97m               differences between them.[0m
echo [97mFIND           Searches for a text string in a file or files.[0m
echo [97mFINDSTR        Searches for strings in files.[0m
echo [97mFOR            Runs a specified command for each file in a set of files.[0m
echo [97mFORMAT         Formats a disk for use with Windows.[0m
echo [97mFSUTIL         Displays or configures the file system properties.[0m
echo [97mFTYPE          Displays or modifies file types used in file extension[0m
echo [97m               associations.[0m
echo [97mGOTO           Directs the Windows command interpreter to a labeled line in[0m
echo [97m               a batch program.[0m
echo [97mGPRESULT       Displays Group Policy information for machine or user.[0m
echo [97mGRAFTABL       Enables Windows to display an extended character set in[0m
echo [97m               graphics mode.[0m
echo [97mHELP           Provides Help information for Windows commands.[0m
echo [97mICACLS         Display, modify, backup, or restore ACLs for files and[0m
echo [97m               directories.[0m
echo [97mIF             Performs conditional processing in batch programs.[0m
echo [97mLABEL          Creates, changes, or deletes the volume label of a disk.[0m
echo [97mMD             Creates a directory.[0m
echo [97mMKDIR          Creates a directory.[0m
echo [97mMKLINK         Creates Symbolic Links and Hard Links[0m
echo [97mMODE           Configures a system device.[0m
echo [97mMORE           Displays output one screen at a time.[0m
echo [97mMOVE           Moves one or more files from one directory to another[0m
echo [97m               directory.[0m
echo [97mOPENFILES      Displays files opened by remote users for a file share.[0m
echo [97mPATH           Displays or sets a search path for executable files.[0m
echo [97mPAUSE          Suspends processing of a batch file and displays a message.[0m
echo [97mPOPD           Restores the previous value of the current directory saved by[0m
echo [97m               PUSHD.[0m
echo [97mPRINT          Prints a text file.[0m
echo [97mPROMPT         Changes the Windows command prompt.[0m
echo [97mPUSHD          Saves the current directory then changes it.[0m
echo [97mRD             Removes a directory.[0m
echo [97mRECOVER        Recovers readable information from a bad or defective disk.[0m
echo [97mREM            Records comments (remarks) in batch files or CONFIG.SYS.[0m
echo [97mREN            Renames a file or files.[0m
echo [97mRENAME         Renames a file or files.[0m
echo [97mREPLACE        Replaces files.[0m
echo [97mRMDIR          Removes a directory.[0m
echo [97mROBOCOPY       Advanced utility to copy files and directory trees[0m
echo [97mSET            Displays, sets, or removes Windows environment variables.[0m
echo [97mSETLOCAL       Begins localization of environment changes in a batch file.[0m
echo [97mSC             Displays or configures services (background processes).[0m
echo [97mSCHTASKS       Schedules commands and programs to run on a computer.[0m
echo [97mSHIFT          Shifts the position of replaceable parameters in batch files.[0m
echo [97mSHUTDOWN       Allows proper local or remote shutdown of machine.[0m
echo [97mSORT           Sorts input.[0m
echo [97mSTART          Starts a separate window to run a specified program or command.[0m
echo [97mSUBST          Associates a path with a drive letter.[0m
echo [97mSYSTEMINFO     Displays machine specific properties and configuration.[0m
echo [97mTASKLIST       Displays all currently running tasks including services.[0m
echo [97mTASKKILL       Kill or stop a running process or application.[0m
echo [97mTIME           Displays or sets the system time.[0m
echo [97mTITLE          Sets the window title for a CMD.EXE session.[0m
echo [97mTREE           Graphically displays the directory structure of a drive or[0m
echo [97m               path.[0m
echo [97mTYPE           Displays the contents of a text file.[0m
echo [97mVER            Displays the Windows version.[0m
echo [97mVERIFY         Tells Windows whether to verify that your files are written[0m
echo [97m               correctly to a disk.[0m
echo [97mVOL            Displays a disk volume label and serial number.[0m
echo [97mXCOPY          Copies files and directory trees.[0m
echo [97mWMIC           Displays WMI information inside interactive command shell.[0m
echo.
exit /b

:show_extra_help
echo [96mHelp and Command Documentation (Extra)[0m
echo [97m====================[0m
echo [94m- sysinfo[0m: Display system information.
echo [94m- settings[0m: Access settings menu for customization.
echo [94m- help[0m: Display the standard Windows command help.
echo [94m- helpextra[0m: Display this extended help message.
echo [94m- ps[0m: List running processes.
echo [94m- network[0m: Display network configuration and connections.
echo [94m- env[0m: Display environment variables.
echo [94m- run [script_name][0m: Execute a batch script.
echo [94m- hiddenmode[0m: Enter hidden mode (not logging commands).
echo.
exit /b

rem Define other labels and functions as needed...
