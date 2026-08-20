import QtQuick
import QtMultimedia
import qs.Ui

// https://gemini.google.com/app/e4a71ef5bc7fcd87

BarWidget {
    id: root
    moduleName: "opoii.clown"

    property bool isPlaying: false
    // Volume level from 0.0 to 1.0 (e.g., 50% volume here)
    property real volumeLevel: 0.5 

    implicitWidth: button.implicitWidth
    implicitHeight: button.implicitHeight

    // Track system multimedia devices
    MediaDevices {
        id: mediaDevices
    }

    MediaPlayer {
        id: player
        source: Qt.resolvedUrl("clown.ogg")
        loops: MediaPlayer.Infinite
        audioOutput: AudioOutput {
            // Bind to the system's current default output device
            device: mediaDevices.defaultAudioOutput
            // This controls only this specific widget's player volume
            volume: root.volumeLevel 
        }
    }

    WidgetButton {
        id: button
        anchors.fill: parent
        bar: root.bar
        text: "🤡"
        active: root.isPlaying
        tooltipText: root.isPlaying ? "Stop music (Vol: " + Math.round(root.volumeLevel * 100) + "%)" : "Play music"
        
        onPressed: function(b) {
            if (root.isPlaying) {
                player.stop()
                root.isPlaying = false
            } else {
                player.play()
                root.isPlaying = true
            }
        }
    }
}