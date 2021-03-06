"
I represent the tree node used to handle ""intra-line-markup"", emphasis, inline code, images and urls.


"
Class {
	#name : #MicInlineBlock,
	#superclass : #Object,
	#instVars : [
		'string',
		'start',
		'end',
		'kind',
		'next',
		'children'
	],
	#category : #'Microdown-Kasper'
}

{ #category : #'as yet unclassified' }
MicInlineBlock class >> pillarNodeFromKind: kind [
	kind = #plain
		ifTrue: [ ^ PRText ].
	kind = #bold
		ifTrue: [ ^ PRBoldFormat ].
	kind = #italics
		ifTrue: [ ^ PRItalicFormat ].
	kind = #block
		ifTrue: [ ^ PRMonospaceFormat ].
	kind = #strike
		ifTrue: [ ^ PRStrikethroughFormat ].
	
	kind = #image ifTrue: [ ^PRFigure  ].
	kind = #link ifTrue: [ ^PRExternalLink   ].
]

{ #category : #'as yet unclassified' }
MicInlineBlock >> asPillar [
	self kind = #plain
		ifTrue: [ ^ PRText new text: self literal ].
	(#(#bold #italics #block #strike) includes: self kind)
		ifTrue: [ ^ (self class pillarNodeFromKind: self kind) new
				setChildren: {(PRText new text: self literal)};
				yourself ]
]

{ #category : #accessing }
MicInlineBlock >> children [
	^ children
]

{ #category : #accessing }
MicInlineBlock >> children: aCollection [
	children := aCollection
]

{ #category : #accessing }
MicInlineBlock >> end [
	^ end
]

{ #category : #accessing }
MicInlineBlock >> end: anObject [
	end := anObject
]

{ #category : #accessing }
MicInlineBlock >> kind [
	^ kind
]

{ #category : #accessing }
MicInlineBlock >> kind: anObject [
	kind := anObject
]

{ #category : #accessing }
MicInlineBlock >> literal [
	^string copyFrom: start to: end. 
]

{ #category : #accessing }
MicInlineBlock >> next [
	^ next
]

{ #category : #accessing }
MicInlineBlock >> next: anObject [
	next := anObject
]

{ #category : #printing }
MicInlineBlock >> printOn: aStream [
	children
		ifNotNil: [ |preSpace| preSpace := false. aStream nextPut: $[.
			children
				do: [ :each | 
					preSpace ifTrue:[aStream nextPut: Character space] ifFalse: [ preSpace := true ].
					each printOn: aStream.].
			aStream nextPut: $] ]
		ifNil:
			[ start isNil | end isNil
				ifTrue: [ aStream << 'Uninitialized MicInlineBlock' ] 
				ifFalse: [  
			start to: end do: [ :index | aStream nextPut: (string at: index) ] ]]
]

{ #category : #split }
MicInlineBlock >> split [
	"if there is any internal structure to the block, decompose it and add children"

	| parts |
	parts := MicIntraBlockSplitter  new splitString: self printString.
	parts size = 1 & (parts first kind = #Plain)
		ifTrue: [ ^ self ].
	self children: parts
]

{ #category : #accessing }
MicInlineBlock >> start [
	^ start
]

{ #category : #accessing }
MicInlineBlock >> start: anObject [
	start := anObject
]

{ #category : #accessing }
MicInlineBlock >> string [
	^ string
]

{ #category : #accessing }
MicInlineBlock >> string: anObject [
	string := anObject
]
