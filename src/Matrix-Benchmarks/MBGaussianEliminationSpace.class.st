Class {
	#name : #MBGaussianEliminationSpace,
	#superclass : #MBGaussianElimination,
	#category : #'Matrix-Benchmarks-Core'
}

{ #category : #normal }
MBGaussianEliminationSpace >> gaussianElimination [

	<name: 'PMLinearEquationSystem'>
	self setupPMLinearEquationSystem.

	^ self bench: [ a1 solution ].
]
