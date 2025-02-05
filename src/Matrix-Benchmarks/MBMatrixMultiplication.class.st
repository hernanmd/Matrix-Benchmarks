"
I benchmark the operation, ""[Matrix Multiplication](https://en.wikipedia.org/wiki/Matrix_multiplication) of 2 matrices"".


Public API and Key Messages

To run the benchmarks
- `MBMatrixMultiplication runBenchmarks: anInteger` runs the benchmarks for a matrix size of `anInteger`.
- `MBMatrixMultiplication  runAllBenchmarks` runs the benchmarks for the matrix sizes from 50 to 300 and shows a line chart plot.
- `MBMatrixMultiplication runAllBenchmarksFrom: fromMatrixSize to: toMatrixSize by: aNumber` runs the benchmarks for the set of matrix sizes specified if it is valid.


This benchmark takes some time to run. But, even big matrix sizes are passed by the API.

"
Class {
	#name : #MBMatrixMultiplication,
	#superclass : #MBAbstract,
	#category : #'Matrix-Benchmarks-Core'
}

{ #category : #accessing }
MBMatrixMultiplication class >> friendlyName [ 


	^ 'Matrix Multiplication '
]

{ #category : #accessing }
MBMatrixMultiplication class >> title [


	^ 'Matrix Multiplication '
]

{ #category : #parameters }
MBMatrixMultiplication >> initRepetitions [ 

	^ 10
]

{ #category : #benchmarks }
MBMatrixMultiplication >> matrixmultiplyAIColumnMatrix [

	
	<benchmark: 'AIColumn'>
	<setup: #setuptwoAIColumnMatrix>

	self initRepetitions timesRepeat:[  a1 *~ a2 ].
	
]

{ #category : #diagonal }
MBMatrixMultiplication >> matrixmultiplyAIDiagonalMatrix [

	
	<benchmark: 'AIDiagonal'>
	<setup: #setuptwoAIDiagonalMatrix>

	self initRepetitions timesRepeat:[  a1 *~ a2 ].
	
]

{ #category : #normal }
MBMatrixMultiplication >> matrixmultiplyAIRowMatrix [

	
	<benchmark: 'AIRow'>
	<setup: #setuptwoAIRowMatrix>

	self initRepetitions timesRepeat:[  a1 *~ a2 ].
	
]

{ #category : #symmetric }
MBMatrixMultiplication >> matrixmultiplyAISymetricMatrix [

	
	<benchmark: 'AISymetric'>
	<setup: #setuptwoAISymetricMatrix>

	self initRepetitions timesRepeat:[  a1 *~ a2 ].
	
]

{ #category : #normal }
MBMatrixMultiplication >> matrixmultiplyArray2D [

	
	<benchmark: 'Array2D'>
	<setup: #setuptwoArray2D>

	self initRepetitions timesRepeat:[  a1 +* a2 ].
	
]

{ #category : #normal }
MBMatrixMultiplication >> matrixmultiplyPMMatrix [

	
	<benchmark: 'PMMatrix'>
	<setup: #setuptwoPMMatrix>

	self initRepetitions timesRepeat:[  a1 * a2 ].
	
]

{ #category : #symmetric }
MBMatrixMultiplication >> matrixmultiplyPMSymmetricMatrix [

	
	<benchmark: 'PMSymmetric'>
	<setup: #setuptwoPMSymmetricMatrix>

	self initRepetitions timesRepeat:[  a1 * a2 ].
	
]
