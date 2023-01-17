;;; ------------------------------------------------------------------------- ;;;
;;; Date created: 2023/01/17
;;; Created By: Garrett Beck
;;; Source: https://github.com/GitHubUser5376/AutoLisp_Debugger/new/main
;;; ------------------------------------------------------------------------- ;;;

;; Global variables
(setq *gbPrint:PrintID* nil)
(setq *gbPrint:IsList* nil)
(setq *gbPrint:bPrintScreen* nil)
(setq *gbPrint:bPrintFile* nil)
(setq *gbPrint:bClearOldLog* nil)

;; Debug Printer
(defun GB:Print (sMsg vValue bValue bType /)

    ;;
    (if (/= 'STR (type sMsg))(progn 
        (GB:Print "Error : An invalid variable type was entered into GB:Print's \"sMsg\".")
        (exit)
    ));if<-progn

    ;; Print to file
    (if *gbPrint:bClearOldLog*
        (progn ;; True
            (setq *gbPrint:PrintID* (open (strcat (getenv "LOCALAPPDATA") "\\Temp\\AutoLisp-Print.txt") "w"))
            (setq *gbPrint:bClearOldLog* nil)
        );progn ; True
        (setq *gbPrint:PrintID* (open (strcat (getenv "LOCALAPPDATA") "\\Temp\\AutoLisp-Print.txt") "a"))
    );if

    ;; Extra space
    (if (and (/= 'LIST (type vValue)) *gbPrint:IsList*)(progn
        (write-line "" *gbPrint:PrintID*)
        (setq *gbPrint:IsList* nil)
    ));if<-progn
    (if (= 'LIST (type vValue))(progn 
        (write-line "" *gbPrint:PrintID*)
        (setq *gbPrint:IsList* T)
    ));if<-progn

    ;; Writing output
    (if *gbPrint:bPrintFile*
        (if bType
            (write-line (strcat sMsg " : " (vl-prin1-to-string (type vValue))) *gbPrint:PrintID*)
            (if (or bValue vValue)
                (write-line (strcat sMsg " : " (vl-prin1-to-string vValue)) *gbPrint:PrintID*)
                (write-line sMsg *gbPrint:PrintID*)
            );if
        );if
    );if

    ;; Printing to the screen
    (if *gbPrint:bPrintScreen* (progn 
        (terpri)(princ sMsg)
        (if bType
            (progn (princ " : ")(prin1 (type vValue)))
            (if (or bValue vValue)(progn (princ " : ")(prin1 vValue)))
        );if
        (terpri)
    ));if<-progn

    (close *gbPrint:PrintID*)
    (setq *gbPrint:PrintID* nil)
    vValue
);GB:Print

;; Ending debug printer
(defun GB:Print-End (/)
    (setq *gbPrint:bPrintScreen* nil)
    (setq *gbPrint:bPrintFile*   nil)
    (setq *gbPrint:bClearOldLog* nil)
    (princ)
);GB:Print-End

;; Starting debug printer
(defun GB:Print-Start (bPrintScreen bPrintFile bClearOldLog /)
    (setq *gbPrint:bPrintScreen* (if bPrintScreen T nil))
    (setq *gbPrint:bPrintFile*   (if bPrintFile   T nil))
    (setq *gbPrint:bClearOldLog* (if bClearOldLog T nil))
    (princ)
);GB:Print-Start
