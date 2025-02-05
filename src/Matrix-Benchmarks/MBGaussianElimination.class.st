"
I benchmark the operation, ""Performing a [Gaussian elimination](https://en.wikipedia.org/wiki/Gaussian_elimination) on a matrix"".

Public API and Key Messages

To run the benchmarks
- `MBGaussianElimination runBenchmarks: anInteger` runs the benchmarks for a matrix size of `anInteger`.
- `MBGaussianElimination runAllBenchmarks` runs the benchmarks for the matrix sizes from 50 to 150 and shows a line chart plot.
- `MBGaussianElimination runAllBenchmarksFrom: fromMatrixSize to: toMatrixSize by: aNumber` runs the benchmarks for the set of matrix sizes specified if it is valid.

This operation takes a lot of time and hence big matrix sizes won't be passed by the API.

"
Class {
	#name : #MBGaussianElimination,
	#superclass : #MBAbstract,
	#category : #'Matrix-Benchmarks-Core'
}

{ #category : #accessing }
MBGaussianElimination class >> friendlyName [ 
	^'Gaussian Elimination of a Matrix'
]

{ #category : #accessing }
MBGaussianElimination class >> title [

	^'Gaussian Elimination '
]

{ #category : #normal }
MBGaussianElimination >> gaussianElimination [


	<benchmark: 'PMLinearEquationSystem'>
	<setup: #setupPMLinearEquationSystem>

	self initRepetitions timesRepeat: [ a1 solution ].
]

{ #category : #parameters }
MBGaussianElimination >> initRepetitions [ 

	^ 1
]

{ #category : #parameters }
MBGaussianElimination >> maxMatrixSize [ 

	^ 300.
]
