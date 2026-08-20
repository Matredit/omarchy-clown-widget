pragma Singleton
import QtQuick
import QtMultimedia

Item {
    id: root
    
    property bool isPlaying: false
    property real volumeLevel: 0.5

    MediaDevices {
        id: mediaDevices
    }

    MediaPlayer {
        id: player
        source: Qt.resolvedUrl("clown.ogg")
        loops: MediaPlayer.Infinite
        audioOutput: AudioOutput {
            device: mediaDevices.defaultAudioOutput
            volume: root.volumeLevel
        }
    }

    function toggle() {
        if (isPlaying) {
            player.stop()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
}