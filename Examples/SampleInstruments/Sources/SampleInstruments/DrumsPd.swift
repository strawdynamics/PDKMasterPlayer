import PlaydateKit
import PDKMasterPlayer

enum DrumsPd {
	private static let pathBase = "synths/drumsPd"

	private typealias NoteProps = SampleInstrument.NoteProps

	static func register() {
		SampleInstrument.register(
			id: "com.ninovanhooff.masterplayer.drums-pd",
			notes: [
				MIDINote(35): NoteProps(path: "\(Self.pathBase)/kick"),
				MIDINote(36): NoteProps(path: "\(Self.pathBase)/kick"),
				MIDINote(38): NoteProps(path: "\(Self.pathBase)/snare"),
				MIDINote(39): NoteProps(path: "\(Self.pathBase)/clap"),
				MIDINote(41): NoteProps(path: "\(Self.pathBase)/tom-low"),
				MIDINote(42): NoteProps(path: "\(Self.pathBase)/hh-closed"),
				MIDINote(43): NoteProps(path: "\(Self.pathBase)/tom-low"),
				MIDINote(44): NoteProps(path: "\(Self.pathBase)/hh-closed"),
				MIDINote(45): NoteProps(path: "\(Self.pathBase)/tom-mid"),
				MIDINote(46): NoteProps(path: "\(Self.pathBase)/hh-open"),
				MIDINote(47): NoteProps(path: "\(Self.pathBase)/tom-mid"),
				MIDINote(48): NoteProps(path: "\(Self.pathBase)/tom-hi"),
				MIDINote(49): NoteProps(path: "\(Self.pathBase)/cymbal-crash"),
				MIDINote(50): NoteProps(path: "\(Self.pathBase)/tom-hi"),
				MIDINote(51): NoteProps(path: "\(Self.pathBase)/cymbal-ride"),
				MIDINote(56): NoteProps(path: "\(Self.pathBase)/cowbell"),
				MIDINote(75): NoteProps(path: "\(Self.pathBase)/clav"),
			]
		)
	}
}
