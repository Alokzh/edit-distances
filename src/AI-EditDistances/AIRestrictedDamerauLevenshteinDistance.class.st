"
The restricted Damerau-Lavenshtein distance, also known as the optimal string alignment distance or restricted edit distance is a string metric for measuring the edit distance between two sequences.

This distance differs from the classical Levenshtein distance by including transpositions among its allowable operations in addition to the three classical single-character edit operations (insertions, deletions and substitutions).

"
Class {
	#name : 'AIRestrictedDamerauLevenshteinDistance',
	#superclass : 'AIAbstractEditDistance',
	#category : 'AI-EditDistances-Distances',
	#package : 'AI-EditDistances',
	#tag : 'Distances'
}

{ #category : 'private' }
AIRestrictedDamerauLevenshteinDistance >> checkSwapsInMatrix: aMatrix at: i at: j basedOn: firstString and: secondString [

	"If while calculating we passed upon two caracters that can be swapped - we take the min between the min calculated before and the (i - 2,j - 2) case value + 1"

	(i > 2 & (j > 2) and: [ 
		 (firstString at: j - 1) = (secondString at: i - 2) and: [ 
			 (firstString at: j - 2) = (secondString at: i - 1) ] ]) ifTrue: [ 
		aMatrix at: i at: j put: { 
				(aMatrix at: i at: j).
				((aMatrix at: i - 2 at: j - 2) + 1) } min ]
]

{ #category : 'api' }
AIRestrictedDamerauLevenshteinDistance >> distanceBetween: firstString and: secondString [

	| distanceMatrix |
	
	"If one of the strings is empty return the other string size"
	firstString isEmpty ifTrue: [ ^ secondString size ].
	secondString isEmpty ifTrue: [ ^ firstString size ].
	
	distanceMatrix := self distanceMatrixBasedOn: firstString and: secondString.

	^ distanceMatrix
		at: distanceMatrix numberOfRows
		at: distanceMatrix numberOfColumns
]

{ #category : 'private' }
AIRestrictedDamerauLevenshteinDistance >> distanceMatrixBasedOn: firstString and: secondString [

    | distanceMatrix |
    distanceMatrix := CTArray2D
        extent: (firstString size + 1) @ (secondString size + 1).

    self fillFirstRowAndColumn: distanceMatrix.

    self fillStartingFromSecondRowAndColumn: distanceMatrix
        basedOn: firstString
        and: secondString.

    ^ distanceMatrix
]

{ #category : 'private' }
AIRestrictedDamerauLevenshteinDistance >> fillCellInMatrix: aMatrix at: i at: j basedOn: firstString and: secondString [

	| cost leftCell upperCell upperLeftCell |
	
	"Setting the cost"
	cost := (firstString at: j - 1) = (secondString at: i - 1)
		ifTrue: [ 0 ]
		ifFalse: [ 1 ].
		
	leftCell := (aMatrix at: i at: j - 1) + 1.
	upperCell := (aMatrix at: i - 1 at: j) + 1.
	upperLeftCell := (aMatrix at: i - 1 at: j - 1) + cost.
	
	"Calculate the min between the left, the upper-left and the upper case of our current case"
	aMatrix at: i at: j put:
		{ leftCell . upperCell . upperLeftCell } min.
]

{ #category : 'private' }
AIRestrictedDamerauLevenshteinDistance >> fillFirstRowAndColumn: distanceMatrix[
    "Initialize the first row and column of the distance matrix with incremental values."
    1 to: distanceMatrix height do: [ :i |
        distanceMatrix atColumn: 1 atRow: i put: i - 1 ].
    1 to: distanceMatrix width do: [ :j |
        distanceMatrix atColumn: j atRow: 1 put: j - 1 ].
]

{ #category : 'private' }
AIRestrictedDamerauLevenshteinDistance >> fillStartingFromSecondRowAndColumn: aMatrix basedOn: firstString and: secondString [
	
	"Begin the loop from the second row/column"
	2 to: aMatrix numberOfRows do: [ :i | 
		2 to: aMatrix numberOfColumns do: [ :j | 
			
			self fillCellInMatrix: aMatrix
				at: i
				at: j
				basedOn: firstString
				and: secondString.
				
			self checkSwapsInMatrix: aMatrix
				at: i
				at: j
				basedOn: firstString
				and: secondString ] ].
]
