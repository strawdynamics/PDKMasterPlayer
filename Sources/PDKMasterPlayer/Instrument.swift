import PlaydateKit

public enum Instrument: CustomStringConvertible {
	case wave(SoundWaveform)
	case sample(String)

	public var description: String {
		switch self {
		case .sample(let name):
			return "sample(\(name))"
		case .wave(let waveform):
			return "wave(\(waveform))"
		}
	}
}
