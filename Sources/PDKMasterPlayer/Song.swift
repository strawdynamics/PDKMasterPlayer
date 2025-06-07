import PlaydateKit
import CPlaydate

class Song {
	let tracks: [Track]

	private class InstrumentData {
		var idInt: Int?
		var idStr: String?
		var name: String?
	}

	private class DecodeContext {
		var tracks = [Track]()
		var currentTrack: Track?
		var isDecodingInstrument = false
		var isDecodingNotes = false
		var currentInstrument = InstrumentData()
	}

	init(songPath: String) {
		let jsonSongPath = "\(songPath).json"
		guard let stat = try? File.stat(path: jsonSongPath) else {
			System.error("[TrackProps] Missing file \(jsonSongPath)")
			tracks = []
			return
		}

		let file = try! File.open(path: jsonSongPath, mode: File.Options.read)

		let fileBuffer = UnsafeMutableRawPointer.allocate(byteCount: Int(stat.size), alignment: 1)

		let bytesRead = try! file.read(buffer: fileBuffer, length: stat.size)

		let uint8Buffer = UnsafeBufferPointer<UInt8>(start: fileBuffer.assumingMemoryBound(to: UInt8.self), count: bytesRead)
		let jsonString = String(decoding: uint8Buffer, as: Unicode.UTF8.self)

		var decoder = JSON.Decoder()
		let ctx = DecodeContext()
		decoder.userdata = Unmanaged.passRetained(ctx).toOpaque()
		decoder.decodeError = Self.decodeError
		decoder.shouldDecodeArrayValueAtIndex = Self.shouldDecodeArrayValue
		decoder.willDecodeSublist = Self.willDecodeSublist
		decoder.didDecodeTableValue = Self.didDecodeTableValue
		decoder.didDecodeArrayValue = Self.didDecodeArrayValue
		decoder.didDecodeSublist = Self.didDecodeSublist

		var value = JSON.Value()

		_ = JSON.decodeString(using: &decoder, jsonString: jsonString, value: &value)

		Unmanaged<DecodeContext>.fromOpaque(decoder.userdata!).release()
		fileBuffer.deallocate()

		tracks = ctx.tracks
	}

	static nonisolated(unsafe) var decodeError: @convention(c)
	(UnsafeMutablePointer<json_decoder>?, UnsafePointer<CChar>?, Int32) -> Void
	= { _, err, line in
		if let e = err.map({ String(cString: $0) }) {
			System.error("JSON error at \(line): \(e)")
		}
	}

	static nonisolated(unsafe) var shouldDecodeArrayValue: @convention(c)
	(UnsafeMutablePointer<json_decoder>?, Int32) -> Int32
	= { ptr, _ in
		guard let dptr = ptr,
			  let ctxPtr = dptr.pointee.userdata
		else { return 0 }
		let ctx = Unmanaged<DecodeContext>.fromOpaque(ctxPtr).takeUnretainedValue()

		if !ctx.isDecodingNotes {
			let t = Track()
			ctx.tracks.append(t)
			ctx.currentTrack = t
		}

		return 1
	}

	static nonisolated(unsafe) var willDecodeSublist: @convention(c)
	(UnsafeMutablePointer<json_decoder>?, UnsafePointer<CChar>?, json_value_type) -> Void
	= { ptr, keyC, type in
		guard
			let dptr = ptr,
			let ctx = dptr.pointee.userdata
				.flatMap({ Unmanaged<DecodeContext>.fromOpaque($0).takeUnretainedValue() }),
			let key = keyC.map(String.init(cString:))?.utf8
		else { return }

		switch (key, type) {
		case ("instrument".utf8, .table):
			ctx.isDecodingInstrument = true
			ctx.currentInstrument = InstrumentData()

		case ("notes".utf8, .array):
			ctx.isDecodingNotes = true

		default:
			break
		}
	}

	static nonisolated(unsafe) var didDecodeTableValue: @convention(c)
	(UnsafeMutablePointer<json_decoder>?, UnsafePointer<CChar>?, json_value) -> Void
	= { ptr, keyC, val in
		guard
			let dptr = ptr,
			let keyC = keyC,
			let ctxPtr = dptr.pointee.userdata
		else { return }

		let key = String(cString: keyC).utf8

		let ctx = Unmanaged<DecodeContext>
			.fromOpaque(ctxPtr)
			.takeUnretainedValue()

		let type = json_value_type(rawValue: numericCast(val.type))

		if ctx.isDecodingInstrument {
			let instr = ctx.currentInstrument

			if key == "id".utf8 {
				switch type {
				case .integer:
					instr.idInt = Int(val.data.intval)
				case .string:
					instr.idStr = String(cString: val.data.stringval)
				default:
					break
				}

			} else if key == "name".utf8 {
				instr.name = String(cString: val.data.stringval)
			}

		} else if let track = ctx.currentTrack {
			switch (key) {
			case "attack".utf8:
				track.attack = val.data.floatval

			case "decay".utf8:
				track.decay = val.data.floatval

			case "isMuted".utf8:
				track.isMuted = type! == json_value_type.true

			case "isSolo".utf8:
				track.isSolo = type! == json_value_type.true

			case "polyphony".utf8:
				track.polyphony = Int(val.data.intval)

			case "release".utf8:
				track.release = val.data.floatval

			case "sustain".utf8:
				track.sustain = val.data.floatval

			case "volume".utf8:
				track.volume = val.data.floatval

			// “notes” is handled in didDecodeArrayValue
			default:
				break
			}
		}
	}

	static nonisolated(unsafe) var didDecodeArrayValue: @convention(c)
	(UnsafeMutablePointer<json_decoder>?, Int32, json_value) -> Void
	= { ptr, _, val in
		guard let dptr = ptr else { return }
		let ctx = Unmanaged<DecodeContext>
			.fromOpaque(dptr.pointee.userdata!)
			.takeUnretainedValue()
		guard let track = ctx.currentTrack else { return }
		if let cPath = dptr.pointee.path {
			let path = String(cString: cPath).utf8
			if path.hasSuffix(".notes") {
				track.notes.append(MIDINote(val.data.intval))
			}
		}
	}

	static nonisolated(unsafe) var didDecodeSublist: @convention(c)
	(UnsafeMutablePointer<json_decoder>?, UnsafePointer<CChar>?, json_value_type)
	-> UnsafeMutableRawPointer?
	= { ptr, _, type in
		guard let dptr = ptr,
			  let ctxPtr = dptr.pointee.userdata
		else { return nil }

		let ctx = Unmanaged<DecodeContext>
			.fromOpaque(ctxPtr)
			.takeUnretainedValue()

		switch type {
		case .table where ctx.isDecodingInstrument:
			if let track = ctx.currentTrack {
				let instr = ctx.currentInstrument
				if let idInt = instr.idInt {
					track.instrument = .wave(SoundWaveform(rawValue: SoundWaveform.RawValue(idInt))!)
				} else if let idStr = instr.idStr {
					track.instrument = .sample(idStr)
				}
			}
			ctx.isDecodingInstrument = false

		case .array where ctx.isDecodingNotes:
			ctx.isDecodingNotes = false

		default:
			break
		}

		return ctxPtr
	}
}
