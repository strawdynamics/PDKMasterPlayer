import PlaydateKit
import PDKMasterPlayer


// MARK: - Game

final class Game: PlaydateGame {
	// MARK: Lifecycle

	init() {
		ChoirAh.register()
		DrumsElectric.register()
		DrumsPd.register()

		masterPlayer = MasterPlayer(songPath: "songs/demo.mid")

		let instructionsBitmap = Graphics.Bitmap(width: 120, height: 60)
		Graphics.pushContext(instructionsBitmap)
		Graphics.drawTextInRect("Ⓐ: Play/pause\nⒷ: Stop\n⬆️⬇️: Volume", in: Rect(
			x: 0,
			y: 0,
			width: 110,
			height: 60
		))
		Graphics.popContext()

		Graphics.drawBitmap(instructionsBitmap, at: Point(
			x: 145,
			y: 90,
		))
	}

	// MARK: Internal

	let masterPlayer: MasterPlayer

	func update() -> Bool {
		let pushed = System.buttonState.pushed

		if pushed.contains(.a) {
			if masterPlayer.isPlaying {
				masterPlayer.pause()
			} else {
				masterPlayer.play()
			}
		} else if pushed.contains(.b) {
			masterPlayer.stop()
		} else if pushed.contains(.up) {
			masterPlayer.volume = fminf(masterPlayer.volume + 0.1, 1)
		} else if pushed.contains(.down) {
			masterPlayer.volume = fmaxf(masterPlayer.volume - 0.1, 0)
		}

		return true
	}
}
