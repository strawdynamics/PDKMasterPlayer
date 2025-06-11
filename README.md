# PDKMasterPlayer

A [MasterPlayer](https://github.com/ninovanhooff/master-player) playback implementation in Swift for use with [PlaydateKit](https://github.com/finnvoor/PlaydateKit).

1. Compose music in your DAW of choice, and export as MIDI.
2. Mix for Playdate with [MIDI Master](https://github.com/ninovanhooff/MIDI-Master).
3. Add `.mid` and `.mid.json` files to your PlaydateKit project, and play back on device!

https://github.com/user-attachments/assets/57d67d63-615c-4d12-ae11-12b8fda24aeb

## Use

See [SampleInstruments](https://github.com/strawdynamics/PDKMasterPlayer/blob/main/Examples/SampleInstruments/Sources/SampleInstruments/Game.swift) for details, including sampled instruments.

```swift
let mp = MasterPlayer(songPath: "songs/aSong.mid")

mp.play()
```
