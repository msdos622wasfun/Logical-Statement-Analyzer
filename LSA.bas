#PBFORMS CREATED V2.01
'------------------------------------------------------------------------------
' The first line in this file is a PB/Forms metastatement.
' It should ALWAYS be the first line of the file. Other
' PB/Forms metastatements are placed at the beginning and
' end of "Named Blocks" of code that should be edited
' with PBForms only. Do not manually edit or delete these
' metastatements or PB/Forms will not be able to reread
' the file correctly.  See the PB/Forms documentation for
' more information.
' Named blocks begin like this:    #PBFORMS BEGIN ...
' Named blocks end like this:      #PBFORMS END ...
' Other PB/Forms metastatements such as:
'     #PBFORMS DECLARATIONS
' are used by PB/Forms to insert additional code.
' Feel free to make changes anywhere else in the file.
'------------------------------------------------------------------------------

#COMPILE EXE
#DIM ALL

'------------------------------------------------------------------------------
'   ** Includes **
'------------------------------------------------------------------------------
#PBFORMS BEGIN INCLUDES
#RESOURCE ICON 104, "Icon.ico"
%USEMACROS = 1
#INCLUDE ONCE "WIN32API.INC"
#INCLUDE ONCE "COMMCTRL.INC"
#INCLUDE ONCE "PBForms.INC"
#INCLUDE ONCE "Version_Info.inc"
#PBFORMS END INCLUDES
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Constants **
'------------------------------------------------------------------------------
#PBFORMS BEGIN CONSTANTS
%IDD_DIALOG_MAIN               =  101
%IDC_FRAME_DIALOG_MAIN         = 1001
%IDC_LABEL_DIALOG_MAIN_01      = 1002
%IDC_LABEL_DIALOG_MAIN_02      = 1012
%IDC_TEXTBOX_DIALOG_MAIN_STATEMENT = 1003
%IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS = 1022
%IDC_BUTTON_DIALOG_MAIN_CLEAR  = 1005
%IDC_BUTTON_DIALOG_MAIN_PRINT  = 1006
%IDC_BUTTON_DIALOG_MAIN_EXPORT = 1007
%IDC_BUTTON_DIALOG_MAIN_ABOUT  = 1011
%IDC_BUTTON_DIALOG_MAIN_SOLVE  = 1021
%IDC_CHECKBOX_DIALOG_MAIN      = 1009
%IDD_DIALOG_ABOUT              =  102
%IDC_BUTTON_DIALOG_ABOUT_OK    = 1017
%IDC_LABEL_DIALOG_ABOUT_01     = 1014
%IDC_LABEL_DIALOG_ABOUT_02     = 1015
%IDC_LABEL_DIALOG_ABOUT_03     = 1016
%IDC_LABEL_DIALOG_ABOUT_04     = 1018
%IDC_FRAME_DIALOG_ABOUT        = 1013
%IDD_DIALOG_EXPORT                  =  103
%IDC_BUTTON_DIALOG_EXPORT_OK        = 1024
%IDC_OPTION_DIALOG_EXPORT_CLIPBOARD = 1025
%IDC_OPTION_DIALOG_EXPORT_FILE      = 1026
%IDC_BUTTON_DIALOG_EXPORT_CANCEL    = 1027
%IDC_FRAME_DIALOG_EXPORT            = 1023
#PBFORMS END CONSTANTS
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Declarations **
'------------------------------------------------------------------------------
DECLARE CALLBACK FUNCTION ShowDIALOG_MAINProc()
DECLARE FUNCTION ShowDIALOG_MAIN(BYVAL hParent AS DWORD) AS LONG
DECLARE CALLBACK FUNCTION ShowDIALOG_EXPORTProc()
DECLARE FUNCTION ShowDIALOG_EXPORT(BYVAL hDlg AS DWORD) AS LONG
DECLARE CALLBACK FUNCTION ShowDIALOG_ABOUTProc()
DECLARE FUNCTION ShowDIALOG_ABOUT(BYVAL hDlg AS DWORD) AS LONG
#PBFORMS DECLARATIONS

' *****************************************************************************
'
' My declarations
'
' *****************************************************************************

$APP_TITLE = "Logical Statement Analyzer"

GLOBAL hDlgMainCopy AS DWORD
GLOBAL hDlgExportCopy AS DWORD
GLOBAL hDlgAboutCopy AS DWORD

'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Main Application Entry Point **
'------------------------------------------------------------------------------
FUNCTION PBMAIN()

    PBFormsInitComCtls (%ICC_WIN95_CLASSES OR %ICC_DATE_CLASSES OR _
        %ICC_INTERNET_CLASSES)

    ShowDIALOG_MAIN %HWND_DESKTOP

END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Menus **
'------------------------------------------------------------------------------
'   ** CallBacks **
'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG_MAINProc()

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler

        CASE %WM_NCACTIVATE
            STATIC hWndSaveFocus AS DWORD
            IF ISFALSE CB.WPARAM THEN
                ' Save control focus
                hWndSaveFocus = GetFocus()
            ELSEIF hWndSaveFocus THEN
                ' Restore control focus
                SetFocus(hWndSaveFocus)
                hWndSaveFocus = 0
            END IF

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_BUTTON_DIALOG_MAIN_SOLVE
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        Solve
                    END IF

                CASE %IDC_BUTTON_DIALOG_MAIN_CLEAR
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        ClearStuff
                    END IF

                CASE %IDC_BUTTON_DIALOG_MAIN_PRINT
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        PrintSolutions
                    END IF

                CASE %IDC_BUTTON_DIALOG_MAIN_EXPORT
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        ExportSolutions
                    END IF

                CASE %IDC_BUTTON_DIALOG_MAIN_ABOUT
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        ShowDIALOG_ABOUT(hDlgMainCopy)
                    END IF
            END SELECT
    END SELECT

END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG_EXPORTProc()

    DIM checked AS LONG

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler

        CASE %WM_NCACTIVATE
            STATIC hWndSaveFocus AS DWORD
            IF ISFALSE CB.WPARAM THEN
                ' Save control focus
                hWndSaveFocus = GetFocus()
            ELSEIF hWndSaveFocus THEN
                ' Restore control focus
                SetFocus(hWndSaveFocus)
                hWndSaveFocus = 0
            END IF

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_BUTTON_DIALOG_EXPORT_OK
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        CONTROL GET CHECK hDlgExportCopy, %IDC_OPTION_DIALOG_EXPORT_CLIPBOARD TO checked
                        IF checked THEN
                            ExportToClipboard
                        ELSE
                            ExportToFile
                        END IF
                        DIALOG END hDlgExportCopy
                    END IF

                CASE %IDC_BUTTON_DIALOG_EXPORT_CANCEL
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END hDlgExportCopy
                    END IF

            END SELECT
    END SELECT
END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
CALLBACK FUNCTION ShowDIALOG_ABOUTProc()

    SELECT CASE AS LONG CB.MSG
        CASE %WM_INITDIALOG
            ' Initialization handler

        CASE %WM_NCACTIVATE
            STATIC hWndSaveFocus AS DWORD
            IF ISFALSE CB.WPARAM THEN
                ' Save control focus
                hWndSaveFocus = GetFocus()
            ELSEIF hWndSaveFocus THEN
                ' Restore control focus
                SetFocus(hWndSaveFocus)
                hWndSaveFocus = 0
            END IF

        CASE %WM_COMMAND
            ' Process control notifications
            SELECT CASE AS LONG CB.CTL
                CASE %IDC_BUTTON_DIALOG_ABOUT_OK
                    IF CB.CTLMSG = %BN_CLICKED OR CB.CTLMSG = 1 THEN
                        DIALOG END hDlgAboutCopy
                    END IF

            END SELECT
    END SELECT

END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
'   ** Dialogs **
'------------------------------------------------------------------------------
FUNCTION ShowDIALOG_MAIN(BYVAL hParent AS DWORD) AS LONG

    LOCAL lRslt AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG_MAIN->->
    LOCAL hDlg   AS DWORD
    LOCAL hFontMSSansSerif12 AS DWORD

    DIALOG NEW hParent, "Logical Statement Analyzer", 350, 250, 440, 290, _
        %WS_POPUP OR %WS_BORDER OR %WS_DLGFRAME OR %WS_SYSMENU OR _
        %WS_MINIMIZEBOX OR %WS_CLIPSIBLINGS OR %WS_VISIBLE OR %DS_MODALFRAME _
        OR %DS_3DLOOK OR %DS_NOFAILCREATE OR %DS_SETFONT, _
        %WS_EX_CONTROLPARENT OR %WS_EX_LEFT OR %WS_EX_LTRREADING OR _
        %WS_EX_RIGHTSCROLLBAR OR %DS_CENTER TO hDlg
    CONTROL ADD TEXTBOX,  hDlg, %IDC_TEXTBOX_DIALOG_MAIN_STATEMENT, "", 165, _
        30, 180, 20
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_DIALOG_MAIN_SOLVE, "&Solve", 360, _
        32, 50, 15, %BS_DEFPUSHBUTTON
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_DIALOG_MAIN_CLEAR, "&Clear", 15, _
        260, 50, 15
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_DIALOG_MAIN_PRINT, "&Print", 80, _
        260, 50, 15
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_DIALOG_MAIN_EXPORT, "E&xport", _
        145, 260, 50, 15
    CONTROL ADD BUTTON,   hDlg, %IDC_BUTTON_DIALOG_MAIN_ABOUT, "&About", 210, _
        260, 50, 15
    CONTROL ADD CHECKBOX, hDlg, %IDC_CHECKBOX_DIALOG_MAIN, "Show solution " + _
        "step-by-step", 325, 265, 100, 10
    CONTROL ADD FRAME,    hDlg, %IDC_FRAME_DIALOG_MAIN, "", 15, 10, 410, 55
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_DIALOG_MAIN_01, "Type your statement " + _
        "in the field:", 30, 25, 120, 10, %WS_CHILD OR %WS_VISIBLE OR _
        %SS_CENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,    hDlg, %IDC_LABEL_DIALOG_MAIN_02, "Legal symbols: T " + _
        "F ( ) [ ] { } && | ! ; =", 30, 45, 120, 10, %WS_CHILD OR _
        %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LISTBOX,  hDlg, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, , 15, 75, 410, 170, _
        %WS_CHILD OR %WS_VISIBLE OR %WS_HSCROLL OR %WS_VSCROLL OR %LBS_NOSEL _
        OR %LBS_NOTIFY OR %LBS_HASSTRINGS, %WS_EX_CLIENTEDGE OR %WS_EX_LEFT _
        OR %WS_EX_LTRREADING OR %WS_EX_RIGHTSCROLLBAR

    FONT NEW "MS Sans Serif", 12, 0, %ANSI_CHARSET TO hFontMSSansSerif12

    CONTROL SET FONT hDlg, %IDC_TEXTBOX_DIALOG_MAIN_STATEMENT, hFontMSSansSerif12
    CONTROL SET FONT hDlg, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, hFontMSSansSerif12

    CONTROL SET CHECK hDlg, %IDC_CHECKBOX_DIALOG_MAIN, 1
#PBFORMS END DIALOG

    hDlgMainCopy = hDlg

    DIALOG SET ICON hDlg, "#104"

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG_MAINProc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG_MAIN
    FONT END hFontMSSansSerif12
#PBFORMS END CLEANUP

    FUNCTION = lRslt

END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION ShowDIALOG_EXPORT(BYVAL hParent AS DWORD) AS LONG

    LOCAL lRslt AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG_EXPORT->->
    LOCAL hDlg  AS DWORD

    DIALOG NEW hParent, "Export Destination", 488, 265, 205, 141, %DS_CENTER TO hDlg
    CONTROL ADD OPTION, hDlg, %IDC_OPTION_DIALOG_EXPORT_CLIPBOARD, _
        "Clipboard", 75, 35, 50, 15
    CONTROL ADD OPTION, hDlg, %IDC_OPTION_DIALOG_EXPORT_FILE, "File", 75, 50, _
        50, 15
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_DIALOG_EXPORT_OK, "OK", 5, 100, 50, _
        14, %WS_CHILD OR %WS_VISIBLE OR %WS_TABSTOP OR %BS_TEXT OR _
        %BS_DEFPUSHBUTTON OR %BS_PUSHBUTTON OR %BS_CENTER OR %BS_VCENTER, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    DIALOG  SEND        hDlg, %DM_SETDEFID, %IDC_BUTTON_DIALOG_EXPORT_OK, 0
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_DIALOG_EXPORT_CANCEL, "Cancel", _
        145, 100, 50, 15
    CONTROL ADD FRAME,  hDlg, %IDC_FRAME_DIALOG_EXPORT, "", 5, 5, 190, 90
#PBFORMS END DIALOG

    hDlgExportCopy = hDlg

    CONTROL SET OPTION hDlgExportCopy, %IDC_OPTION_DIALOG_EXPORT_CLIPBOARD,_
     %IDC_OPTION_DIALOG_EXPORT_CLIPBOARD, %IDC_OPTION_DIALOG_EXPORT_FILE

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG_EXPORTProc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG_EXPORT
#PBFORMS END CLEANUP

    FUNCTION = lRslt

END FUNCTION
'------------------------------------------------------------------------------

'------------------------------------------------------------------------------
FUNCTION ShowDIALOG_ABOUT(BYVAL hParent AS DWORD) AS LONG

    LOCAL lRslt AS LONG

#PBFORMS BEGIN DIALOG %IDD_DIALOG_ABOUT->->
    LOCAL hDlg  AS DWORD

    DIALOG NEW hParent, "About This Program", 555, 288, 200, 158, %DS_CENTER TO hDlg
    CONTROL ADD BUTTON, hDlg, %IDC_BUTTON_DIALOG_ABOUT_OK, "OK", 72, 95, 50, _
        15, %BS_DEFPUSHBUTTON
    CONTROL ADD FRAME,  hDlg, %IDC_FRAME_DIALOG_ABOUT, "", 10, 5, 175, 125
    CONTROL ADD LABEL,  hDlg, %IDC_LABEL_DIALOG_ABOUT_01, "Logical Statement " + _
        "Analyzer", 15, 20, 165, 10, %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, _
        %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,  hDlg, %IDC_LABEL_DIALOG_ABOUT_02, "Copyleft 2020 by " + _
        "Erich Kohl", 15, 30, 165, 10, %WS_CHILD OR %WS_VISIBLE OR _
        %SS_CENTER, %WS_EX_LEFT OR %WS_EX_LTRREADING
    CONTROL ADD LABEL,  hDlg, %IDC_LABEL_DIALOG_ABOUT_03, "Version 2.00", 15, _
        40, 165, 10, %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
    CONTROL ADD LABEL,  hDlg, %IDC_LABEL_DIALOG_ABOUT_04, "This is free and " + _
        "open-source software distributed under the GNU/GPL 3.0 license.", 15, 60, _
        165, 20, %WS_CHILD OR %WS_VISIBLE OR %SS_CENTER, %WS_EX_LEFT OR _
        %WS_EX_LTRREADING
#PBFORMS END DIALOG

    hDlgAboutCopy = hDlg

    DIALOG SHOW MODAL hDlg, CALL ShowDIALOG_ABOUTProc TO lRslt

#PBFORMS BEGIN CLEANUP %IDD_DIALOG_ABOUT
#PBFORMS END CLEANUP

    FUNCTION = lRslt

END FUNCTION
'------------------------------------------------------------------------------

' *****************************************************************************
'
' My procedures
'
' *****************************************************************************

SUB ClearStuff()

    CONTROL SET TEXT hDlgMainCopy, %IDC_TEXTBOX_DIALOG_MAIN_STATEMENT, ""
    LISTBOX RESET hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS

END SUB

SUB ExportSolutions()

    DIM listboxLength AS LONG

    LISTBOX GET COUNT hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS TO listboxLength

    IF listboxLength > 0 THEN
        ShowDIALOG_EXPORT(hDlgMainCopy)
    END IF

END SUB

SUB ExportToClipboard()

    DIM listboxLength AS LONG
    DIM lin AS STRING
    DIM temp AS STRING
    DIM a AS LONG

    CLIPBOARD RESET

    LISTBOX GET COUNT hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS TO listboxLength

    FOR a = 1 TO listboxLength
        LISTBOX GET TEXT hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, a TO lin
        temp = temp & lin & $CRLF
    NEXT a

    CLIPBOARD SET TEXT temp

    MSGBOX "Export to clipboard successful.", %MB_OK OR %MB_ICONINFORMATION OR %MB_TASKMODAL, $APP_TITLE

END SUB

SUB ExportToFile()

    DIM listboxLength AS LONG
    DIM lin AS STRING
    DIM fn AS STRING
    DIM e AS INTEGER
    DIM a AS LONG

    DISPLAY SAVEFILE hDlgExportCopy, , , "", CURDIR$,_
     "Text files (*.txt)" & CHR$(0) & "*.txt" & CHR$(0) & "All files (*.*)" & CHR$(0) & "*.*" & CHR$(0),_
     "", "*.txt", %OFN_PATHMUSTEXIST OR %OFN_CREATEPROMPT OR %OFN_OVERWRITEPROMPT TO fn

    IF LEN(fn) THEN
        ON ERROR GOTO ErrorTrap
        LISTBOX GET COUNT hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS TO listboxLength
        OPEN fn FOR OUTPUT AS #1
        IF e = 0 THEN
            FOR a = 1 TO listboxLength
                LISTBOX GET TEXT hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, a TO lin
                PRINT #1, lin
                IF e THEN EXIT FOR
            NEXT a
        END IF
        CLOSE #1
    END IF

    ON ERROR GOTO 0

    MSGBOX "Export to file successful.", %MB_OK OR %MB_ICONINFORMATION OR %MB_TASKMODAL, $APP_TITLE

    EXIT SUB

    ErrorTrap:

    e = ERR
    ERRCLEAR
    RESUME NEXT

END SUB

SUB PrintSolutions()

    DIM listboxLength AS LONG
    DIM lin AS STRING
    DIM e AS INTEGER
    DIM a AS LONG

    LISTBOX GET COUNT hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS TO listboxLength

    IF listboxLength = 0 THEN
        EXIT SUB
    END IF

    ON ERROR GOTO ErrorTrap

    XPRINT ATTACH CHOOSE, "LSA_PRINT_JOB"

    IF e = 0 THEN
        IF LEN(XPRINT$) > 0 THEN
            FOR a = 1 TO listboxLength
                LISTBOX GET TEXT hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, a TO lin
                XPRINT PRINT lin
                IF e THEN EXIT FOR
            NEXT a
            XPRINT CLOSE
        END IF
    END IF

    ON ERROR GOTO 0

    EXIT SUB

    ErrorTrap:

    e = ERR
    ERRCLEAR
    RESUME NEXT

END SUB

SUB Solve()

    DIM Statement AS STRING
    DIM Temp AS STRING
    DIM SyntaxError AS INTEGER
    DIM Solutions AS STRING
    DIM StepByStep AS LONG
    DIM e AS INTEGER
    DIM i AS INTEGER

    CONTROL GET CHECK hDlgMainCopy, %IDC_CHECKBOX_DIALOG_MAIN TO StepByStep
    CONTROL GET TEXT hDlgMainCopy, %IDC_TEXTBOX_DIALOG_MAIN_STATEMENT TO Statement

    Statement = TRIM$(UCASE$(Statement))
    Temp = ""

    FOR i = 1 TO LEN(Statement)
        IF ASC(MID$(Statement, i, 1)) <> 32 THEN
            Temp = Temp & MID$(Statement, i, 1)
        END IF
    NEXT i

    Statement = Temp

    IF LEN(Statement) > 30 THEN
        MSGBOX "Statement cannot exceed 30 characters.", %MB_OK OR %MB_ICONWARNING OR %MB_TASKMODAL, $APP_TITLE
        EXIT SUB
    ELSEIF LEN(Statement) = 0 THEN
        EXIT SUB
    END IF

    SyntaxError = %FALSE

    LISTBOX ADD hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, ">>>>> SOLVE: " & Statement
    IF ISTRUE(StepByStep) THEN
        LISTBOX ADD hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, Statement
    END IF

    ON ERROR GOTO ErrorTrap

    DO
        Temp = ""
        FOR i = 1 TO LEN(Statement)
            SELECT CASE MID$(Statement, i, 1)
                CASE "{", "[", "("
                    IF i <= LEN(Statement) - 2 THEN
                        IF INSTR("T)T]T}F)F]F}", MID$(Statement, i + 1, 2)) THEN
                            Temp = Temp & MID$(Statement, i + 1, 1)
                            Temp = Temp & RIGHT$(Statement, LEN(Statement) - (i + 2))
                            EXIT FOR
                        END IF
                    END IF
                CASE "&"
                    IF i > 1 AND i <= LEN(Statement) - 1 THEN
                        IF INSTR("T&TT&FF&TF&F", MID$(Statement, i - 1, 3)) THEN
                            IF MID$(Statement, i - 1, 3) = "T&T" THEN
                                Temp = LEFT$(Statement, i - 2) & "T"
                            ELSE
                                Temp = LEFT$(Statement, i - 2) & "F"
                            END IF
                            Temp = Temp & RIGHT$(Statement, LEN(Statement) - (i + 1))
                            EXIT FOR
                        END IF
                    END IF
                CASE "|"
                    IF i > 1 AND i <= LEN(Statement) - 1 THEN
                        IF INSTR("T|TT|FF|TF|F", MID$(Statement, i - 1, 3)) THEN
                            IF MID$(Statement, i - 1, 3) = "F|F" THEN
                                Temp = LEFT$(Statement, LEN(Temp) - 1) & "F"
                            ELSE
                                Temp = LEFT$(Statement, LEN(Temp) - 1) & "T"
                            END IF
                            Temp = Temp & RIGHT$(Statement, LEN(Statement) - (i + 1))
                            EXIT FOR
                        END IF
                    END IF
                CASE "!"
                    IF i <= LEN(Statement) - 1 THEN
                        IF INSTR("TF", MID$(Statement, i + 1, 1)) THEN
                            IF MID$(Statement, i + 1, 1) = "T" THEN
                                Temp = Temp & "F"
                            ELSE
                                Temp = Temp & "T"
                            END IF
                            Temp = Temp & RIGHT$(Statement, LEN(Statement) - (i + 1))
                            EXIT FOR
                        END IF
                    END IF
                CASE ";"
                    IF i > 1 AND i <= LEN(Statement) - 1 THEN
                        IF INSTR("T;TT;FF;TF;F", MID$(Statement, i - 1, 3)) THEN
                            IF MID$(Statement, i - 1, 3) = "T;F" THEN
                                Temp = LEFT$(Statement, LEN(Temp) - 1) & "F"
                            ELSE
                                Temp = LEFT$(Statement, LEN(Temp) - 1) & "T"
                            END IF
                            Temp = Temp & RIGHT$(Statement, LEN(Statement) - (i + 1))
                            EXIT FOR
                        END IF
                    END IF
                CASE "="
                    IF i > 1 AND i <= LEN(Statement) - 1 THEN
                        IF INSTR("T=TT=FF=TF=F", MID$(Statement, i - 1, 3)) THEN
                            IF MID$(Statement, i - 1, 1) = MID$(Statement, i + 1, 1) THEN
                                Temp = LEFT$(Statement, LEN(Temp) - 1) & "T"
                            ELSE
                                Temp = LEFT$(Statement, LEN(Temp) - 1) & "F"
                            END IF
                            Temp = Temp & RIGHT$(Statement, LEN(Statement) - (i + 1))
                            EXIT FOR
                        END IF
                    END IF
            END SELECT
            Temp = Temp & MID$(Statement, i, 1)
        NEXT i

        IF Temp = Statement AND Temp <> "T" AND Temp <> "F" THEN
            SyntaxError = %TRUE
        ELSE
            Statement = Temp
        END IF

        IF ISFALSE(SyntaxError) AND StepByStep = 1 THEN
            LISTBOX ADD hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, Statement
            IF e THEN
                ON ERROR GOTO 0
                EXIT SUB
            END IF
        END IF

    LOOP UNTIL LEN(Statement) = 1 OR ISTRUE(SyntaxError)

    IF ISFALSE(SyntaxError) THEN
        LISTBOX ADD hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, ">>>>> SOLUTION: " & Statement
        LISTBOX ADD hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, " "
    ELSE
        LISTBOX ADD hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, "*** SYNTAX ERROR ***"
        LISTBOX ADD hDlgMainCopy, %IDC_LISTBOX_DIALOG_MAIN_SOLUTIONS, " "
    END IF

    ON ERROR GOTO 0

    EXIT SUB

    ErrorTrap:

    e = ERR
    ERRCLEAR
    RESUME NEXT

END SUB
