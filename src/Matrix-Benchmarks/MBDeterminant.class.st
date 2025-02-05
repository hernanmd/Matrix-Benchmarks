"
I benchmark the operation, ""finding determinant of a matrix"".
https://en.wikipedia.org/wiki/Determinant


Public API and Key Messages

To run the benchmarks
- `MBDeterminant runBenchmarks: anInteger` runs the benchmarks for a matrix size of `anInteger`.
- `MBDeterminant  runAllBenchmarks` runs the benchmarks for the matrix sizes from 50 to 150 and shows a line chart plot.
- `MBDeterminant runAllBenchmarksFrom: fromMatrixSize to: toMatrixSize by: aNumber` runs the benchmarks for the set of matrix sizes specified if it is valid.

Only, `PMMatrix` and `PMSymmetricMatrix` are compared as the other implementations don't support finding determinant.

Since, finding determinant takes considerable time, only small matrix sizes will be passed to run the benchmarks.
"
Class {
	#name : #MBDeterminant,
	#superclass : #MBAbstract,
	#category : #'Matrix-Benchmarks-Core'
}

{ #category : #accessing }
MBDeterminant class >> friendlyName [ 


	^ 'Determinant of a Matrix'
]

{ #category : #accessing }
MBDeterminant class >> title [


	^ 'Determinant '
]

{ #category : #normal }
MBDeterminant >> determinantPMMatrix [


	<benchmark: 'PMMatrix'>
	<setup: #setupPMMatrix>

	self initRepetitions timesRepeat: [ a1 determinant ].
]

{ #category : #symmetric }
MBDeterminant >> determinantPMSymmetricMatrix [


	<benchmark: 'PMSymmetric'>
	<setup: #setupPMSymmetricMatrix>

	self initRepetitions timesRepeat: [ a1 determinant ].
]

{ #category : #parameters }
MBDeterminant >> initRepetitions [ 

	^ 1
]

{ #category : #parameters }
MBDeterminant >> maxMatrixSize [ 

	^ 300
]
