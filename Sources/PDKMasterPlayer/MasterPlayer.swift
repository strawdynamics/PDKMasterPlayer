import PlaydateKit

public class MasterPlayer {
	let songPath: String

	let songInfo: Song

	let sequence: Sound.Sequence

	public var volume: Float = 1.0 {
		didSet {
			updateTrackVolumes()
		}
	}

	public var isPlaying: Bool {
		return sequence.isPlaying
	}

	public init(songPath: String) {
		self.songPath = songPath

		songInfo = Song(songPath: songPath)
		sequence = Self.loadMidi(songPath: songPath, trackCount: songInfo.tracks.count)

		var i = 0
		for track in songInfo.tracks {
			let instrument = Sound.Instrument(track: track)
			sequence.tracks[i].instrument = instrument

			i += 1
		}

		// Initial track volume normalization
		updateTrackVolumes()
	}

	public func play() {
		sequence.setLoops(startStep: 0, endStep: sequence.length)
		sequence.play()
	}

	public func pause() {
		sequence.stop()
	}

	public func stop() {
		sequence.stop()
		sequence.time = 0
	}

	private func updateTrackVolumes() {
		zip(songInfo.tracks, sequence.tracks).forEach { props, track in
			let effectiveVolume = volume * props.volume
			track.instrument!.volume = (effectiveVolume, effectiveVolume)
		}
	}

	private static func loadMidi(songPath: String, trackCount: Int) -> Sound.Sequence {
		let seq = Sound.Sequence()
		let loaded = seq.loadMIDIFile(path: songPath)

		if !loaded {
			System.error("[Midi] Load error")
		}

		let seqTrackCount = seq.trackCount

		print("[Midi] Loaded \(seqTrackCount) tracks from \(songPath)")

		if seqTrackCount == 0 {
			do {
				_ = try File.stat(path: songPath)

				System.error("[Midi] No tracks")
			} catch {
				System.error("[Midi] File missing")
			}
		}

		if seqTrackCount != trackCount {
			System.error("[Midi] Incorrect track count \(seqTrackCount), expected \(trackCount)")
		}

		return seq
	}
}
