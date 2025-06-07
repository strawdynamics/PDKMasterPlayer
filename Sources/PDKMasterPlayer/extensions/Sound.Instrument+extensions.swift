import PlaydateKit

extension Sound.Instrument {
	private static func configureWaveInstrument(
		_ inst: Sound.Instrument,
		_ track: Track
	) {
		guard case let .wave(waveform) = track.instrument else {
			System.error("[Midi] Invalid instrument")
			return
		}

		for _ in 0..<track.polyphony {
			let synth = Sound.Synth()
			synth.setWaveform(waveform)
			synth.setAttackTime(track.attack)
			synth.setDecayTime(track.decay)
			synth.setSustainLevel(track.sustain)
			synth.setReleaseTime(track.release)

			_ = inst.addVoice(
				synth: synth,
				rangeStart: MIDINote(track.notes.first!),
				rangeEnd: MIDINote(track.notes.last!)
			)
		}
	}

	private static func createSampleSynth(
		samplePath: String,
		track: Track
	) -> Sound.Synth {
		let synth = Sound.Synth()
		let sample = SampleInstrument.Cache.getOrLoad(samplePath)

		synth.setSample(sample)
		synth.setAttackTime(track.attack)
		synth.setDecayTime(track.decay)
		synth.setSustainLevel(track.sustain)
		synth.setReleaseTime(track.release)

		return synth
	}

	private static func configureSampleInstrument(
		_ inst: Sound.Instrument,
		_ track: Track
	) {
		guard case let .sample(instrumentId) = track.instrument else {
			System.error("[Midi] Invalid instrument")
			return
		}

		guard let sampleInst = SampleInstrument.instruments[instrumentId.utf8] else {
			System.error("[Midi] Sample instrument \(instrumentId) not registered. Call `SampleInstrument.register`")
			return
		}

		track.notes.forEach { note in
			guard let noteProps = sampleInst.notes[note] else {
				print("[Midi] Note \(Int(note)) not found in instrument \(instrumentId)")
				return
			}

			let noteStart = noteProps.noteStart ?? note
			let noteEnd = noteProps.noteEnd ?? noteStart
			let noteRoot = noteProps.noteRoot ?? noteStart
			let offset = noteRoot - noteStart
			let transpose = Float(NOTE_C4) - noteStart - offset

			let synth = Self.createSampleSynth(samplePath: noteProps.path, track: track)

			_ = inst.addVoice(synth: synth, rangeStart: noteStart, rangeEnd: noteEnd, transpose: transpose)
		}
	}

	convenience init(track: Track) {
		self.init()
		
		switch track.instrument {
		case .wave:
			Self.configureWaveInstrument(self, track)
		case .sample:
			Self.configureSampleInstrument(self, track)
		}

		// https://discord.com/channels/675983554655551509/1217244550666518589/1377598500400922686
		_ = Sound.defaultChannel.addSource(self)
	}
}
