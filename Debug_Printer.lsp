;;; ------------------------------------------------------------------------- ;;;
;;; Date created: 2023/01/17
;;; Created By: Garrett Beck
;;; Source: https://github.com/GitHubUser5376/AutoLisp_Debugger/new/main
;;; ------------------------------------------------------------------------- ;;;

;; Global variables
(setq *gbPrint:IsList* nil)
(setq *gbPrint:bPrintScreen* nil)
(setq *gbPrint:bPrintFile* nil)
(setq *gbPrint:bClearOldLog* nil)

;; Debug Printer
(defun GB:Print (sMsg vValue bValue bType / sString FileID)

    ;; Error catch
    (if (/= 'STR (type sMsg))(progn 
        (GB:Print "Error : An invalid variable type was entered into GB:Print's \"sMsg\".")
        (GB:Print "Error. Invalid variable type" sMsg nil T)
        (exit)
    ));if<-progn

    ;; Print to file - Clear / Append
    (cond 
        (   *gbPrint:bClearOldLog*
            (setq FileID (open (strcat (getenv "LOCALAPPDATA") "\\Temp\\AutoLisp-Print.txt") "w"))
            (setq *gbPrint:bClearOldLog* nil)
        ); Condition 1
        ;; Condition 2
        (   *gbPrint:bPrintFile*
            (setq FileID (open (strcat (getenv "LOCALAPPDATA") "\\Temp\\AutoLisp-Print.txt") "a"))
        ); Condition 2
    );if

    ;; Extra space - Output file only
    (cond 
        ;; Condition 1 - Adds a new line after the list value, before the next value type is added.
        (   (and *gbPrint:bPrintFile* (/= 'LIST (type vValue)) *gbPrint:IsList*)
            (write-line "" FileID)
            (setq *gbPrint:IsList* nil)
        ); Condition 1
        ;; Condition 2 - Adds a new line before the list's value is added.
        (   (and *gbPrint:bPrintFile* (= 'LIST (type vValue)))
            (write-line "" FileID)
            (setq *gbPrint:IsList* T)
        ); Condition 2
    );cond

    ;; Outbound message
    (setq sString (cond 
        (bType (strcat sMsg " : " (vl-prin1-to-string (type vValue))));-----; Condition 1
        ((or bValue vValue) (strcat sMsg " : " (vl-prin1-to-string vValue))); Condition 2
        (T sMsg); Else
    ));setq<-cond

    ;; Writing to output file
    (if *gbPrint:bPrintFile* (write-line sString FileID))

    ;; Printing to the screen
    (if *gbPrint:bPrintScreen* (princ sString))
    (setq FileID (close FileID))
    
    ;; Return value
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
