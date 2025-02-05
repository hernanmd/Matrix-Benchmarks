"
Main UI class for user-based execution of Matrix Benchmarking operations.

With this UI the user can specify the parameter of interest, run and visualize results in a graphical way.

MBApplication new start.
"
Class {
	#name : #MBApplication,
	#superclass : #SpApplication,
	#category : #'Matrix-Benchmarks-UI'
}

{ #category : #menu }
MBApplication class >> menu00MatrixBenchmarksOn: aBuilder [

	<worldMenu>
	(aBuilder item: #MB)
		parent: #Tools;
		label: 'Matrix Benchmarks';
		help: 'Open the Matrix Benchmarks Spec Application';
		order: 778;
		action: [ MBPresenter new openWithSpec ]
]

{ #category : #initialization }
MBApplication >> initialize [ 

	^ self 
		useBackend: #Morphic
		with: MBApplicationConfiguration new.
]

{ #category : #accessing }
MBApplication >> start [

	^ (self new: MBPresenter) openWithSpec.
]
