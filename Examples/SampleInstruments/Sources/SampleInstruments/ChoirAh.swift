import PlaydateKit
import PDKMasterPlayer

enum ChoirAh {
	private static let pathBase = "synths/choirAh"

	private typealias NoteProps = SampleInstrument.NoteProps

	static func register() {
		let noteDefs = [
			NoteProps(
				path: "\(Self.pathBase)/Choir-C3",
				noteStart: 47,
				noteRoot: 48,
				noteEnd: 49,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-D#3",
				noteStart: 50,
				noteRoot: 51,
				noteEnd: 52,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-F#3",
				noteStart: 53,
				noteRoot: 54,
				noteEnd: 55,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-A3",
				noteStart: 56,
				noteRoot: 57,
				noteEnd: 58,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-C4",
				noteStart: 59,
				noteRoot: 60,
				noteEnd: 61,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-D#4",
				noteStart: 62,
				noteRoot: 63,
				noteEnd: 64,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-F#4",
				noteStart: 65,
				noteRoot: 66,
				noteEnd: 67,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-A4",
				noteStart: 68,
				noteRoot: 69,
				noteEnd: 70,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-C5",
				noteStart: 71,
				noteRoot: 72,
				noteEnd: 73,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-D#5",
				noteStart: 74,
				noteRoot: 75,
				noteEnd: 76,
			),
			NoteProps(
				path: "\(Self.pathBase)/Choir-F#5",
				noteStart: 77,
				noteRoot: 78,
				noteEnd: 79,
			),
		]

		var noteMap: [MIDINote: NoteProps] = [:]
		for def in noteDefs {
			guard let start = def.noteStart,
				  let end = def.noteEnd else { continue }
			for note in Int(start)...Int(end) {
				noteMap[MIDINote(note)] = def
			}
		}


		SampleInstrument.register(
			id: "com.ninovanhooff.masterplayer.choir-ah",
			notes: noteMap,
		)
	}
}
