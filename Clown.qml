import QtQuick
import QtMultimedia
import qs.Ui

// https://gemini.google.com/app/e4a71ef5bc7fcd87

BarWidget {
    id: root
    moduleName: "opoii.clown"

    property bool isPlaying: false

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
        }
    }

    WidgetButton {
        id: button
        anchors.fill: parent
        bar: root.bar
        text: "🤡"
        active: root.isPlaying
        tooltipText: root.isPlaying ? "Stop music" : "Play music"
        
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