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
		play(loopStartStep: 0)
	}

	/// If `loopStartStep` or `loopEndStep` are negative, they're used as an offset from the end of the sequence.
	public func play(loopStartStep: Int, loopEndStep: Int? = nil) {
		play(fromStep: 0, loopStartStep: loopStartStep, loopEndStep: loopEndStep)
	}

	/// If `fromStep`, `loopStartStep` or `loopEndStep` are negative, they're used as an offset from the end of the sequence.
	public func play(fromStep: Int, loopStartStep: Int = 0, loopEndStep: Int? = nil) {
		let seqLen = sequence.length
		let from = fromStep < 0 ? seqLen + fromStep : fromStep
		let start = loopStartStep < 0 ? seqLen + loopStartStep : loopStartStep
		let end = loopEndStep.map { $0 < 0 ? seqLen + $0 : $0 } ?? sequence.length

		sequence.setLoops(
			startStep: start,
			endStep: end
		)

		sequence.setCurrentStep(from)
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
