;;; --------------------------------------------------------------------------------- ;;;
;;; Created By:   Garrett Beck
;;; Date Created: 2023/01/17
;;; Source:       https://github.com/GitHubUser5376/AutoLisp_Find_Value
;;; Example:      (FindValue nil "ByLayer")
;;; --------------------------------------------------------------------------------- ;;;

(defun FindValue-Debugger (sTag vValue / *lVlaObjects* *vla-getlist* ObjPath *lResults* lResult *error*)
    ;;; ------------------------------------------------------------------------- ;;;
    ;;; Local functions ----------------------------------------- Local functions ;;;

    ;; Source: https://forums.autodesk.com/t5/visual-lisp-autolisp-and-general/vlax-dump-object/m-p/1079460/highlight/true#M155423
    
    ;; Returns all properties
    (defun FindValue:vla-getlist (/ fcnLambda01 fcnLambda02 fcnLambda03 lBadProperties)
        (setq fcnLambda01 (function (lambda (x) (wcmatch (strcase x) "VLA-GET-*"))))
        (setq fcnLambda02 (function (lambda (x) (substr x 9))))
        (setq fcnLambda03 (function (lambda (x) (member x lBadProperties))))
        (setq lBadProperties '("AUTOTRACKINGVECCOLOR" "COORDINATE" "DASHLENGTHAT" 
            "GRAPHICSWINLAYOUTBACKGRNDCOLOR" "GRAPHICSWINMODELBACKGRNDCOLOR" 
            "LAYOUTCROSSHAIRCOLOR" "LINETYPEAT" "MODELCROSSHAIRCOLOR" "MRUNUMBER" "OFFSETAT" 
            "SHAPENUMBERAT" "SHAPEOFFSETAT" "SHAPEROTATIONAT" "SHAPESCALEAT" "SHAPESTYLEAT" 
            "STATUSID" "TEXTAT" "TEXTWINBACKGRNDCOLOR" "TEXTWINTEXTCOLOR"
        ));setq<-quote (list)
        (setq *vla-getlist* (vl-remove-if-not fcnLambda01 (atoms-family 1)))
        (setq *vla-getlist* (mapcar fcnLambda02 *vla-getlist*))
        (setq *vla-getlist* (vl-remove-if fcnLambda03 *vla-getlist*))
    );FindValue:vla-getlist

    ;; Returns available properties
    (defun FindValue:vl-property-available (en / fcnLambda01 fcnLambda02 lBadProperties lReturn)
        (setq fcnLambda01 (function (lambda (x) (vlax-property-available-p en x))))
        (setq lReturn (vl-remove-if-not fcnLambda01 *vla-getlist*))
    );FindValue:vl-property-available

    ;;; Local functions ----------------------------------------- Local functions ;;;
    ;;; ------------------------------------------------------------------------- ;;;
    ;;; Recursive function ----------------------------------- Recursive function ;;;
    
    ;; Checks all objects for matching inputs
    (defun RecursiveFind (sTag vValue vlaObject lPath / 
        lProperties sProperty vProperty objItem lReturn iItr1 *iItr2*)

        (GB:Print "==============================================================")
        ;(GB:Print "sTag     " sTag      T nil)
        ;(GB:Print "vValue   " vValue    T nil)
        (GB:Print "vlaObject" vlaObject T nil)
        (GB:Print "lPath    " (reverse lPath) T nil)
        (GB:Print "iItr1" (setq *iItr1*  (1+ *iItr1* )) T)
        (GB:Print "Level" (setq *iLevel* (1+ *iLevel*)) T)

        ;; Adding object to the list
        (setq *lVlaObjects* (cons vlaObject *lVlaObjects*))

        ;; Collecting properties
        (setq lProperties (FindValue:vl-property-available vlaObject))
        (GB:Print "lProperties" lProperties T nil)

        ;; Each property within the object
        (setq lReturn (list))
        (foreach sProperty lProperties
            (GB:Print "sProperty" sProperty T)
            (setq vProperty (vl-catch-all-apply 'vlax-get (list vlaObject sProperty)))
            (GB:Print "vProperty" vProperty T)
            (GB:Print "")
            ;; Recording matching properties
            (cond 
                ;; Condition 1
                ((and sTag vValue)
                    (if (and (= vValue vProperty)(= sTag sProperty))
                        (setq lReturn (cons (list (reverse lPath) sProperty vProperty) lReturn))
                    );if
                ); Condition 1
                ;; Condition 2
                (sTag
                    (if (= sTag sProperty)
                        (setq lReturn (cons (list (reverse lPath) sProperty vProperty) lReturn))
                    );if
                ); Condition 2
                ;; Condition 3
                (vValue
                    (if (= vValue vProperty)
                        (setq lReturn (cons (list (reverse lPath) sProperty vProperty) lReturn))
                    );if
                ); Condition 3
            );cond
            
            ;; Object Recursion
            (if (and (= (type vProperty) 'VLA-OBJECT)(not (member vProperty *lVlaObjects*)))
                (setq lReturn (append lReturn 
                    (RecursiveFind sTag vValue vProperty (cons sProperty lPath))
                ));setq<-append
            );if

            ;; List Recursion
            (if (and (= sProperty "COUNT")(= (type vProperty) 'INT))(progn
                (setq iItr1 0)
                (vlax-for objItem vlaObject
                    (if (and (not (member objItem *lVlaObjects*))(= (type objItem) 'VLA-OBJECT))
                        (setq lReturn (append lReturn 
                            (RecursiveFind sTag vValue objItem (cons (strcat "ITEM " (itoa iItr1)) lPath))
                        ));setq<-append
                    );if
                    (setq iItr1 (1+ iItr1))
                );vlax-for
            ));if<-progn
        );foreach

        (GB:Print "Level-End" *iLevel* T)
        (GB:Print "--------------------------------------------------------------")
        (setq *iLevel* (1- *iLevel*))

        lReturn
    );RecursiveFind

    ;;; Recursive function ----------------------------------- Recursive function ;;;
    ;;; ------------------------------------------------------------------------- ;;;
    ;;; Function call --------------------------------------------- Function call ;;;

    ;; Starting recursive search - Returns list variable
    (setq *iItr1* 0)
    (setq *iLevel* 0)
    (FindValue:vla-getlist)
    (if (= sTag "")(setq sTag nil))
    (GB:Print-Start nil T T)
    (setq *lResults* (RecursiveFind sTag vValue (vlax-get-acad-object) nil))
    (GB:Print-End)
    (princ "\n*lResults* : ")(prin1 *lResults*)(terpri)

    ;; Printing results
    (foreach lResult *lResults* 
        (princ "\n---------------------------------------\n")
        (foreach ObjPath (nth 0 lResult)(princ "\nObject : ")(prin1 ObjPath)(terpri))
        (princ "\nTag   : ")(prin1 (nth 1 lResult))(terpri)
        (princ "\nValue : ")(prin1 (nth 2 lResult))(terpri)
    );foreach
    (princ)
    *iItr1*
);FindValue
