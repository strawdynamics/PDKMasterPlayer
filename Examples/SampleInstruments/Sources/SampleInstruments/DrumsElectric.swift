import PlaydateKit
import PDKMasterPlayer

enum DrumsElectric {
	private static let pathBase = "synths/drumsElectric"

	private typealias NoteProps = SampleInstrument.NoteProps

	static func register() {
		let tom3 = NoteProps(
			path: "\(Self.pathBase)/3-ElecTom3Mono",
			noteStart: 47,
			noteEnd: 48,
		)

		SampleInstrument.register(
			id: "com.ninovanhooff.masterplayer.drums-electric",
			notes: [
				MIDINote(36): NoteProps(path: "\(Self.pathBase)/3-ElecBD2Mono"),
				MIDINote(38): NoteProps(path: "\(Self.pathBase)/key38-Acoustic Snare 1"),
				MIDINote(40): NoteProps(path: "\(Self.pathBase)/drm-ElecPowerSnar(L"),
				MIDINote(41): NoteProps(path: "\(Self.pathBase)/3-ElecTom5Mono"),
				MIDINote(42): NoteProps(path: "\(Self.pathBase)/0-HiHatClosedSter(L"),
				MIDINote(43): NoteProps(path: "\(Self.pathBase)/3-ElecTom5Mono"),
				MIDINote(45): NoteProps(path: "\(Self.pathBase)/3-ElecTom5Mono"),
				MIDINote(46): NoteProps(path: "\(Self.pathBase)/0-HiHatOpenStereo(L"),
				MIDINote(47): tom3,
				MIDINote(48): tom3,
				MIDINote(49): NoteProps(path: "\(Self.pathBase)/key49-crash cymbal 1"),
				MIDINote(51): NoteProps(path: "\(Self.pathBase)/key51-Ride cymbal 1"),
				MIDINote(52): NoteProps(path: "\(Self.pathBase)/key52-Chinese Cymbal"),
				// "simply sounds weird. Perhaps needs looping params?"
				MIDINote(53): NoteProps(path: "\(Self.pathBase)/key53-acRideBell"),
				MIDINote(55): NoteProps(path: "\(Self.pathBase)/key55-Splash cymbal"),
				MIDINote(57): NoteProps(path: "\(Self.pathBase)/key57-crash cymbal 2"),
				MIDINote(59): NoteProps(path: "\(Self.pathBase)/key59-Ride cymbal 2"),
			]
		)
	}
}
