#lang scheme
; ---------------------------------------------
; DO NOT REMOVE OR CHANGE ANYTHING UNTIL LINE 26
; ---------------------------------------------

; Copyright ChatGPT - This was used in the process of this language.
; Nicholas McCarty - CSE 465 - Meisam Amjad (Comparative Programming Languages)

; zipcodes.scm contains all the US zipcodes.
; This file must be in the same folder as hw2.scm file.
; You should not modify this file. Your code
; should work for other instances of this file.
(require "zipcodes.scm")

; Helper function
(define (mydisplay value)
	(display value)
	(newline)
)

; Helper function
(define (line func)
        (display "--------- ")
        (display func)
        (display " ------------")
        (newline)
)

; ================ Solve the following functions ===================
; Return a list with only the negatives items
(define (negatives lst)
  (if (null? lst) 
          '()
          (if (< (car lst) 0)  ; Check if the first element is negative
          (cons (car lst) (negatives (cdr lst)))
          (negatives (cdr lst))
                 )
)
  )

(line "negatives")
(mydisplay (negatives '()))  ; -> ()
(mydisplay (negatives '(-1)))  ; -> (-1)
(mydisplay (negatives '(-1 1 2 3 4 -4 5)))  ; -> (-1 -4)
(mydisplay (negatives '(1 1 2 3 4 4 5)))  ; -> ()
(line "negatives")
; ---------------------------------------------

; Returns true if the two lists have identical structure
; in terms of how many elements and nested lists they have in the same order
(define (struct lst1 lst2)
  (cond ((and (null? lst1) (null? lst2)) #t)  ; Both lists are empty
        ((or (null? lst1) (null? lst2)) #f)  ; One list is empty, and the other is not
        ((and (list? (car lst1)) (list? (car lst2)))  ; Both heads are lists
         (and (struct (car lst1) (car lst2)) (struct (cdr lst1) (cdr lst2))))
        ((or (list? (car lst1)) (list? (car lst2))) #f)  ; One head is a list, the other is not
        (else (struct (cdr lst1) (cdr lst2)))))  ; Both heads are not lists


(line "struct")
(mydisplay (struct '(a b c (c a b)) '(1 2 3 (a b c))))  ; -> #t
(mydisplay (struct '(a b c d (c a b)) '(1 2 3 (a b c))))  ; -> #f
(mydisplay (struct '(a b c (c a b)) '(1 2 3 (a b c) 0)))  ; -> #f
(line "struct")
; ---------------------------------------------

; Returns a list of two numeric values. The first is the smallest
; in the list and the second is the largest in the list. 
; lst -- contains numeric values, and length is >= 1.
(define (minAndMax lst)
  (list (apply min lst) (apply max lst)))

(line "minAndMax")
(mydisplay (minAndMax '(1 2 -3 4 2)))  ; -> (-3 4)
(mydisplay (minAndMax '(1)))  ; -> (1 1)
(line "minAndMax")
; ---------------------------------------------

; Returns a list identical to the first list, while having all elements
; that are inside nested loops taken out. So we want to flatten all elements and have
; them all in a single list. For example '(a (a a) a))) should become (a a a a)
(define (flatten lst)
  (if (null? lst)
      '()
      (if (list? (car lst))
          (append (flatten (car lst)) (flatten (cdr lst)))
          (cons (car lst) (flatten (cdr lst))))))

(line "flatten")
(mydisplay (flatten '(a b c)))  ; -> (a b c)
(mydisplay (flatten '(a (a a) a)))  ; -> (a a a a)
(mydisplay (flatten '((a b) (c (d) e) f)))  ; -> (a b c d e f)
(line "flatten")
; ---------------------------------------------

; The paramters are two lists. The result should contain the cross product
; between the two lists: 
; The inputs '(1 2) and '(a b c) should return a single list:
; ((1 a) (1 b) (1 c) (2 a) (2 b) (2 c))
; lst1 & lst2 -- two flat lists.
(define (crossproduct lst1 lst2)
  (if (null? lst1)
      '()
      (append (crossproduct-pair (car lst1) lst2)
              (crossproduct (cdr lst1) lst2))))

(define (crossproduct-pair item lst2)
  (if (null? lst2)
      '()
      (cons (list item (car lst2))
            (crossproduct-pair item (cdr lst2)))))

(line "crossproduct")
(mydisplay (crossproduct '(1 2) '(a b c)))
(line "crossproduct")
; ---------------------------------------------

; Returns the first latitude and longitude of a particular zip code.
; if there are multiple latitude and longitude pairs for the same zip code,
; the function should only return the first pair. e.g. (53.3628 -167.5107)
; zipcode -- 5 digit integer
; zips -- the zipcode DB- You MUST pass the 'zipcodes' function
; from the 'zipcodes.scm' file for this. You can just call 'zipcodes' directly
; as shown in the sample example
(define (getLatLon zipcode zips)
  (let loop ((zips zips))
    (if (null? zips)
        '() ; Return an empty list if the zipcode is not found
        (let ((current (car zips)))
          (if (= zipcode (car current)) ; Compare the zipcode with the first element of the current entry
              (list (cadr (cdr (cdr (cdr current)))) ; Extract latitude
                    (caddr (cdr (cdr (cdr current))))) ; Extract longitude
              (loop (cdr zips))))))) ; Continue with the rest of the list if no match



(line "getLatLon")
(mydisplay (getLatLon 45056 zipcodes))
(line "getLatLon")
; ---------------------------------------------

; Returns a list of all the place names common to two states.
; placeName -- is the text corresponding to the name of the place
; zips -- the zipcode DB
(define (getCommonPlaces state1 state2 zips)
  (define common-places '())
  (let loop1 ((zips1 zips))
    (if (null? zips1)
        common-places
        (let ((current1 (car zips1)))
          (if (equal? state1 (caddr current1))
              (let loop2 ((zips2 zips))
                (cond ((null? zips2)
                       (loop1 (cdr zips1)))
                      ((and (equal? state2 (caddr (car zips2)))
                            (equal? (cadr current1) (cadr (car zips2))))
                       (set! common-places (cons (cadr current1) common-places))
                       (loop1 (cdr zips1)))
                      (else (loop2 (cdr zips2)))))
              (loop1 (cdr zips1)))))))
(line "getCommonPlaces")
(mydisplay (getCommonPlaces "OH" "MI" zipcodes))
(line "getCommonPlaces")
; ---------------------------------------------

; #### Only for Graduate Students ####
; Returns a list of all the place names common to a set of states.
; states -- is list of state names
; zips -- the zipcode DB
(define (getCommonPlaces2 states zips)
	'("Oxford" "Franklin")
)

(line "getCommonPlaces2")
(mydisplay (getCommonPlaces2 '("OH" "MI" "PA") zipcodes))
(line "getCommonPlaces2")
; ---------------------------------------------

; Returns the number of zipcode entries for a particular state.
; state -- state
; zips -- zipcode DB
(define (zipCount state zips)
  (if (null? zips) ; If the list is empty, return the count as 0
      0
      (let ((currentEntry (car zips)) ; Extract the current entry from the list
            (restEntries (cdr zips))) ; The rest of the entries
        (if (string=? state (caddr currentEntry)) ; Compare the state with the third element of the entry
            (+ 1 (zipCount state restEntries)) ; If it matches, increment the count and recurse on the rest
            (zipCount state restEntries))))) ; Otherwise, just recurse on the rest without incrementing

(line "zipCount")
(mydisplay (zipCount "OH" zipcodes))
(line "zipCount")
; ---------------------------------------------

; #### Only for Graduate Students ####
; Returns the distance between two zip codes in "meters".
; Use lat/lon. Do some research to compute this.
; You can find some info here: https://www.movable-type.co.uk/scripts/latlong.html
; zip1 & zip2 -- the two zip codes in question.
; zips -- zipcode DB
(define (getDistanceBetweenZipCodes zip1 zip2 zips)
	0
)

(line "getDistanceBetweenZipCodes")
(mydisplay (getDistanceBetweenZipCodes 45056 48122 zipcodes))
(line "getDistanceBetweenZipCodes")
; ---------------------------------------------

; Some sample predicates
(define (POS? x) (> x 0))
(define (NEG? x) (< x 0))
(define (LARGE? x) (>= (abs x) 10))
(define (SMALL? x) (not (LARGE? x)))

; Returns a list of items that satisfy a set of predicates.
; For example (filterList '(1 2 3 4 100) '(EVEN?)) should return the even numbers (2 4 100)
; (filterList '(1 2 3 4 100) '(EVEN? SMALL?)) should return (2 4)
; lst -- flat list of items
; filters -- list of predicates to apply to the individual elements

(define (filterList lst filters)
  (if (null? lst) ; If the list is empty, return an empty list
      '()
      (let ((item (car lst)) ; Take the first item of the list
            (rest (cdr lst))) ; The rest of the list
        (if (apply-all-filters item filters) ; Check if the item passes all filters
            (cons item (filterList rest filters)) ; If yes, include it in the output
            (filterList rest filters))))) ; Otherwise, skip it

(define (apply-all-filters item filters)
  (if (null? filters) ; If there are no more filters, the item passes
      #t
      (if ((car filters) item) ; Apply the current filter to the item
          (apply-all-filters item (cdr filters)) ; If passed, check next filter
          #f))) ; If any filter fails, return false

(line "filterList")
(mydisplay (filterList '(1 2 3 11 22 33 -1 -2 -3 -11 -22 -33) (list POS?)))
(mydisplay (filterList '(1 2 3 11 22 33 -1 -2 -3 -11 -22 -33) (list POS? even?)))
(mydisplay (filterList '(1 2 3 11 22 33 -1 -2 -3 -11 -22 -33) (list POS? even? LARGE?)))
(line "filterList")
; ---------------------------------------------

