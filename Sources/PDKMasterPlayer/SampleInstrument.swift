import PlaydateKit

public class SampleInstrument {
	static nonisolated(unsafe) var instruments: [String.UTF8View: SampleInstrument] = [:]

	enum Cache {
		private static nonisolated(unsafe) var samples: [String.UTF8View: Sound.Sample] = [:]

		static func getOrLoad(_ samplePath: String) -> Sound.Sample {
			if samples[samplePath.utf8] != nil {
				return samples[samplePath.utf8]!
			}

			let sample = Sound.Sample(path: samplePath)!
			samples[samplePath.utf8] = sample

			return sample
		}
	}

	public struct NoteProps {
		public let path: String
		public var noteStart: MIDINote?
		public var noteRoot: MIDINote?
		public var noteEnd: MIDINote?

		public init(
			path: String,
			noteStart: MIDINote? = nil,
			noteRoot: MIDINote? = nil,
			noteEnd: MIDINote? = nil,
		) {
			self.path = path
			self.noteStart = noteStart
			self.noteEnd = noteEnd
			self.noteRoot = noteRoot
		}
	}

	let id: String

	let notes: [MIDINote: NoteProps]

	private init(id: String, notes: [MIDINote: NoteProps]) {
		self.id = id
		self.notes = notes
	}

	@discardableResult public static func register(
		id: String,
		notes: [MIDINote: NoteProps],
	) -> SampleInstrument {
		let inst = SampleInstrument(id: id, notes: notes)

		Self.instruments[id.utf8] = inst

		return inst
	}
}
