"
I am an abstract class to run the time benchmarks.

I provide methods to set up all kinds of matrices.

```Smalltalk
MBAbstract new matrixSize: 100; setupPMMatrix.
```
sets the instance variable `a1` to a random PMMatrix of size of 100.

I also provide methods to run the benchmarks on the subclasses.

Public API and Key Messages

```Smalltalk
MBAbstract operations
```
lists down all the operations for which benchmarks have been implemented.



    Class Variables
	protocol:		<Object> stores the type of the matrix - {normal, symmetric, diagonal}


"
Class {
	#name : #MBAbstract,
	#superclass : #MBSpaceAbstract,
	#instVars : [
		'a1',
		'a2',
		'aNumber'
	],
	#classInstVars : [
		'protocol',
		'UI'
	],
	#category : #'Matrix-Benchmarks-Core'
}

{ #category : #private }
MBAbstract class >> displayStackedVisualizations [

	^ UI class displayStackedVisualizations
]

{ #category : #accessing }
MBAbstract class >> friendlyName [
	^ self subclassResponsibility
]

{ #category : #examples }
MBAbstract class >> operations [

	|operations|
	" list all the available operations that can be benchmarked"
	operations := OrderedCollection new.
	self subclassesDo: [ :each | operations addLast: each ].
	^ operations
]

{ #category : #'accessing - private' }
MBAbstract class >> protocol [
	^ protocol.
]

{ #category : #'running - benchmark' }
MBAbstract class >> runAllBenchmarks [
	"runs the benchmarks from the sizes 50 to 300 if the operation is not too time-consuming.
	Otherwise benchmarks are run from 50 to 150."
	
	self new defaultMaxMatrixSize  >= 500 ifTrue: [
		 ^ self runAllBenchmarksFrom: 50 to: 300 by: 50 ]
	ifFalse: [ 
		^ self runAllBenchmarksFrom: 50 to: 150 by: 25
		 ]

]

{ #category : #'running - benchmark' }
MBAbstract class >> runAllBenchmarksFrom: fromMatrixSize to: toMatrixSize [ 
	
	|stepValue|
	self assert: toMatrixSize > (fromMatrixSize + 1) description: 'to matrix size should be greater than from matrix size'.

	" find a suitable gap to run the benchmarks for around 6 different matrix sizes"
	stepValue := ((toMatrixSize - fromMatrixSize)/5) ceiling.

	^ self runAllBenchmarksFrom: fromMatrixSize  to: toMatrixSize  by: stepValue 
]

{ #category : #'running - benchmark' }
MBAbstract class >> runAllBenchmarksFrom: fromMatrixSize to: toMatrixSize by: aNumber [
	
	self assert: toMatrixSize > (fromMatrixSize + 1) description: 'to matrix size should be greater than from matrix size'.
	

	^ self runAndPlotAllBenchmarksFrom: fromMatrixSize to: toMatrixSize by: aNumber.

]

{ #category : #private }
MBAbstract class >> runAllBenchmarksWithProtocolFrom: fromMatrixSize to: toMatrixSize by: aNumber [

	|result|
	
	"runs the benchmarks from the sizes fromMatrixSize toMatrixSize with a gap of aNumber"

	result := OrderedCollection new.

	(fromMatrixSize to: toMatrixSize  by: aNumber) do: [ :each| result addLast: (self new class runBenchmarksWithProtocol: each)] displayingProgress: [:each | 'Benchmarking Matrix size ', each asString].
	.
	^ result.
	
]

{ #category : #'plotting - benchmarks' }
MBAbstract class >> runAndPlotAllBenchmarksFrom: fromMatrixSize to: toMatrixSize by: aNumber [

	|protocols|
	
	protocols := #('normal' 'symmetric' 'diagonal').
	
	protocols do: [ :each|
		(self protocols includes: each) ifTrue: [ 
			protocol := each.
			self runAndPlotAllBenchmarksWithProtocolFrom: fromMatrixSize to: toMatrixSize by: aNumber
			 ]
		].
]

{ #category : #private }
MBAbstract class >> runAndPlotAllBenchmarksWithProtocolFrom: fromMatrixSize to: toMatrixSize by: aNumber [

	|result|

	result := self new class runAllBenchmarksWithProtocolFrom: fromMatrixSize to: toMatrixSize by: aNumber. 
	"sorting the implementations alphabetically"
	result := self sortResult: result.
	
	"visulize the benchmark"
	MBBenchmarkVisualizer  plotBenchmarksLineGraph: result title: self title protocol: protocol.



]

{ #category : #'plotting - benchmarks' }
MBAbstract class >> runAndPlotBenchmarks: anInteger [

	|protocols|
	
	protocols := #( 'diagonal' 'symmetric' 'normal' ).
	
	protocols do: [ :each|
		(self protocols includes: each) ifTrue: [ 
			protocol := each.
			self runAndPlotBenchmarksWithProtocol: anInteger.
			 ]
		] displayingProgress: [:each | 'Benchmarking ', each, 'matrices'].
]

{ #category : #private }
MBAbstract class >> runAndPlotBenchmarksWithProtocol: anInteger [

	|aBenchmark |


	aBenchmark := self new class runBenchmarksWithProtocol: anInteger .
	" visulize the benchmark"
	UI class plotBenchmarksBarGraph: aBenchmark title: self title protocol: protocol.
	
	^aBenchmark
]

{ #category : #'running - benchmark' }
MBAbstract class >> runBenchmarks [

	^ self runBenchmarks: self new defaultMatrixSize.
	


]

{ #category : #'running - benchmark' }
MBAbstract class >> runBenchmarks: anInteger [
	|integerasString aBenchmarkSuite|
	
	integerasString := anInteger asString.
	
	"run space benchmarks"
	self  runSpaceBenchmarks: anInteger.

	"run time benchmarks"
	#(1) do: [ :garbage|
	aBenchmarkSuite := (BenchmarkSuite class: self new class ) run: BenchmarkResultC new with: (Dictionary new at: #'matrixSize' put: integerasString ;yourself)
		]displayingProgress: 'Benchmarking ...'.

	aBenchmarkSuite outcomes do: [ :each | 
		" add the information of space benchmarks"
		each spaceMeasurements: (self spaceBenchmarkResult at: each benchmark name ).
		 ].
	
	"plot the benchmark results"
	UI := MBBenchmarkVisualizer new.
	UI class initializeCanvas.
	self runAndPlotBenchmarks: anInteger.
	self displayStackedVisualizations.

	"store the benchmark class in the report for the user to check how the operations have been implemented"
	aBenchmarkSuite benchmarkClass: self new.
	
	^ aBenchmarkSuite 
	
]

{ #category : #private }
MBAbstract class >> runBenchmarksWithProtocol: anInteger [
		|integerasString selectors suite result|
	
	 "runs the benchmarks contained in the particular protocol.
	  For example, protocol -> symmetric, runs PMSymmetricMatrix and AISymmetricMatrix."
		integerasString := anInteger asString.
	
		selectors := self selectorsInProtocol: protocol.
		suite := BenchmarkSuite new.
		selectors do: [ :each | suite addBenchmark: (BenchmarkInstance class: self selector: each) ].
		#(1) do: [ :garbage|
			result := suite run: BenchmarkResultC new with: (Dictionary new at: #'matrixSize' put: integerasString ; yourself) ] displayingProgress: 'Benchmarking time..'.
		
		^ result

	
]

{ #category : #'accessing - private' }
MBAbstract class >> sortResult: aBenchmarkResultSet [
	
	"sort the outcomes in the result set based on the name of the matrix implementation"
	^ aBenchmarkResultSet  collect: [ :each | each outcomes asSortedCollection: [ :c :d | c benchmark name <= d benchmark name] ].
]

{ #category : #accessing }
MBAbstract class >> title [
	^ self subclassResponsibility
]

{ #category : #parameters }
MBAbstract >> checkMatrixSize [
	"checks if the matrix size is too big."
	"big matrix sizes are not passed considering time constraints."
	self assert: matrixSize <= self maxMatrixSize description: 'Matrix Size is too big'
]

{ #category : #parameters }
MBAbstract >> defaultInitRepetitions [ 
	^ 100.
]

{ #category : #parameters }
MBAbstract >> defaultMatrixSize [
	

	^ 100

	
	
]

{ #category : #parameters }
MBAbstract >> defaultMaxMatrixSize [
	^ 500.
]

{ #category : #parameters }
MBAbstract >> initRepetitions [ 
	^ self defaultInitRepetitions
]

{ #category : #parameters }
MBAbstract >> matrixSize [
	

	^ matrixSize

	
	
]

{ #category : #parameters }
MBAbstract >> matrixSize: anInteger [
	

	<parameter: #matrixSize type: #Integer default: 100 >

	matrixSize := anInteger.

	
	
]

{ #category : #parameters }
MBAbstract >> maxMatrixSize [ 
	^ self defaultMaxMatrixSize
]

{ #category : #setupOneMatrix }
MBAbstract >> setupAIColumnMatrix [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	a1 := AIColumnMatrix new: size.

	
	1 to: size do: [ :i | 
		1 to: size do: [ :j |
			a1 at: i and: j put: (100 random) ] ].
	
	
]

{ #category : #setupOneMatrix }
MBAbstract >> setupAIDiagonalMatrix [


	|aArray size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	aArray := Array new: size.
	1 to: size do: [ :i | aArray at: i put: (100 random) ].
	
	a1 := AIDiagonalMatrix withDiagonal: aArray.
	
]

{ #category : #setupOneMatrix }
MBAbstract >> setupAIRowMatrix [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	a1 := AIRowMatrix new: size.

	
	1 to: size do: [ :i | 
		1 to: size do: [ :j |
			a1 at: i and: j put: (100 random) ] ].
	
	
]

{ #category : #setupOneMatrix }
MBAbstract >> setupAISymetricMatrix [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	a1 := AISymetricMatrix new: size.

	1 to: size do: [ :i | 
		1 to: i do: [ :j |
			a1 at: i and: j put: (100 random) ] ].
	
	1 to: size do: [ :i|
		i+1 to: size do:[:j|
			a1 at: i and: j put: (a1 at:j and: i) ] ].
	
	
]

{ #category : #setupOneMatrix }
MBAbstract >> setupArray2D [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	a1 := Array2D new: size.
	
	1 to: size do: [ :i | 
		1 to: size do: [ :j |
			a1 at: i at: j put: (100 random) ] ].
	
]

{ #category : #setupInvertibleMatrix }
MBAbstract >> setupInvertiblePMMatrix [
	" 2 triangular matrices( upper and lower) are generated.
	They are multipied to generate the invertible matrix"
	
	|l u size|
	
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	l := PMMatrix zerosRows: size cols: size.
	
	1 to: size do: [ :i|
	1 to: i-1 do:[ :j|
		l at: i at: j put: (10 random)
		 ]].
	" principal diagonal elements can not be zero"
	1 to: size do: [ :i|
	l at: i at: i put: (10 random)+1 ].

	u := PMMatrix zerosRows: size cols: size.

	1 to: size do: [ :i|
		i+1 to: size do:[ :j|
			u at: i at: j put: (10 random)
		 ]].
	1 to: size do: [ :i|
		u at: i at: i put: (10 random)+1 ].

	a1 := l*u.

]

{ #category : #setupInvertibleMatrix }
MBAbstract >> setupInvertiblePMSymmetricMatrix [
	"A full rank symmetric matrix AtA is generated,
	where A is a random symmetric matrix."
	
	|size|
	
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size:= matrixSize.
	a1 := PMSymmetricMatrix new: size.
	
	1 to: size do: [ :i | 
		1 to: i do: [ :j |
			a1 at: i at: j put: (10 random) ] ].
	
	1 to: size do: [ :i|
		i+1 to: size do:[:j|
			a1 at: i at: j put: (a1 at:j at: i) ] ].
	a1 := a1 transpose * a1.
]

{ #category : #setupNumber }
MBAbstract >> setupNumber [
	
	"0 is avoided"
	aNumber := (10000 random) + 1.

	
	
]

{ #category : #setupSpecial }
MBAbstract >> setupPMJacobiTransformation [
	
	
	self setupPMMatrix.

	a1 := PMJacobiTransformation matrix: a1.


]

{ #category : #setupSpecial }
MBAbstract >> setupPMLUPDecomposition [ 
	
	
	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	self setupPMMatrix.
	
	a2 := PMVector new: size.
	1 to: size do: [ :i|
		a2 at: i put: (10 random) ].
	
	a1 := PMLUPDecomposition equations: a1 rows.





]

{ #category : #setupSpecial }
MBAbstract >> setupPMLinearEquationSystem [
	
	" Random matrix and vector is generated.
	If the matrix is singular, solution will just return nil."
	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	self setupPMMatrix.
	
	a2 := PMVector new: size.
	1 to: size do: [ :i|
		a2 at: i put: (10 random) ].
	
	a1 := PMLinearEquationSystem equations: a1 rows constant: a2 asArray.





]

{ #category : #setupOneMatrix }
MBAbstract >> setupPMMatrix [


	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	a1 := PMMatrix new: size.
	
	1 to: size do: [ :i | 
		1 to: size do: [ :j |
			a1 at: i at: j put: (100 random) ] ].
	
]

{ #category : #setupOneMatrix }
MBAbstract >> setupPMSymmetricMatrix [


	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	a1 := PMSymmetricMatrix new: size.
	
	1 to: size do: [ :i | 
		1 to: i do: [ :j |
			a1 at: i at: j put: (100 random) ] ].
	
	1 to: size do: [ :i|
		i+1 to: size do:[:j|
			a1 at: i at: j put: (a1 at:j at: i) ] ].
	
]

{ #category : #setupStrassen }
MBAbstract >> setupStrassenPMMatrix [


	
	"matrixSize should be a power of 2"
	self assert: matrixSize isPowerOfTwo  description: 'matrixSize should be a power of 2'.
	self checkMatrixSize. " checks if the matrix size is too big"
	
	self setuptwoPMMatrix .
	
]

{ #category : #setupStrassen }
MBAbstract >> setupStrassenPMSymmetricMatrix [


	"matrixSize should be a power of 2"
	self assert: (matrixSize isPowerOfTwo ) description: 'matrixSize should be a power of 2'.
	self checkMatrixSize. " checks if the matrix size is too big"
	
	self setuptwoPMSymmetricMatrix.
]

{ #category : #setupTwoMatrix }
MBAbstract >> setuptwoAIColumnMatrix [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	self setupAIColumnMatrix.
	a2 := AIColumnMatrix new: size.
	
	1 to: size do: [ :i | 
		1 to: size do: [ :j |
			a2 at: i and: j put: (100 random) ] ].
]

{ #category : #setupTwoMatrix }
MBAbstract >> setuptwoAIDiagonalMatrix [

	|size aArray|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	self setupAIDiagonalMatrix .
	
	aArray := Array new: size.

	1 to: size do: [ :i | aArray at: i put: (100 random) ].
	
	a2 := AIDiagonalMatrix withDiagonal: aArray.
]

{ #category : #setupTwoMatrix }
MBAbstract >> setuptwoAIRowMatrix [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	self setupAIRowMatrix.
	
	a2 := AIRowMatrix new: size.
	
	1 to: size do: [ :i | 
		1 to: size do: [ :j |
			a2 at: i and: j put: (100 random) ] ].
]

{ #category : #setupTwoMatrix }
MBAbstract >> setuptwoAISymetricMatrix [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	self setupAISymetricMatrix.
	
	a2 := AISymetricMatrix new: size.

	1 to: size do: [ :i | 
		1 to: i do: [ :j |
			a2 at: i and: j put: (100 random) ] ].
	
	1 to: size do: [ :i|
		i+1 to: size do:[:j|
			a2 at: i and: j put: (a2 at:j and: i) ] ].
	
]

{ #category : #setupTwoMatrix }
MBAbstract >> setuptwoArray2D [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	
	self setupArray2D.
	a2 := Array2D new: size.
	
	1 to: size do: [ :i | 
		1 to: size do: [ :j |
			a2 at: i at: j put: (100 random) ] ].
]

{ #category : #setupTwoMatrix }
MBAbstract >> setuptwoPMMatrix [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	self setupPMMatrix.
	a2 := PMMatrix new: size.
	
	1 to: size do: [ :i | 
		1 to: size do: [ :j |
			a2 at: i at: j put: (100 random) ] ].
]

{ #category : #setupTwoMatrix }
MBAbstract >> setuptwoPMSymmetricMatrix [

	|size|
	self checkMatrixSize. " checks if the matrix size is too big"
	
	size := matrixSize.
	self setupPMSymmetricMatrix.
	
	a2 := PMSymmetricMatrix new: size.
	
	1 to: size do: [ :i | 
		1 to: i do: [ :j |
			a2 at: i at: j put: (100 random) ] ].
	
	1 to: size do: [ :i|
		i+1 to: size do:[:j|
			a2 at: i at: j put: (a2 at:j at: i) ] ].
]
