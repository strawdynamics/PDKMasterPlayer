import PlaydateKit

class Track {
	var attack: Float = 0
	var decay: Float = 0
	var instrument: Instrument = .wave(.sine)
	var isMuted: Bool = false
	var isSolo: Bool = false
	var notes: [MIDINote] = []
	var polyphony: Int = 0
	var release: Float = 0
	var sustain: Float = 0
	var volume: Float = 0
}
