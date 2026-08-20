import QtQuick
import QtMultimedia
import qs.Ui

// https://gemini.google.com/app/e4a71ef5bc7fcd87

BarWidget {
    id: root
    moduleName: "opoii.clown"

    property bool isPlaying: false
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
        
        tooltipText: {
            let volPercent = Math.round(root.volumeLevel * 100)
            return root.isPlaying ? "Stop (Vol: " + volPercent + "%)" : "Play (Vol: " + volPercent + "%)"
        }
        
        onPressed: function(b) {
            if (root.isPlaying) {
                player.stop()
                root.isPlaying = false
            } else {
                player.play()
                root.isPlaying = true
            }
        }

        onWheelMoved: function(delta) {
            // 5% step is too high for touchpad gesture, so
            if (delta === 0) return

            // Mouse wheels report chunks of 120. Touchpads report smaller continuous values.
            let isMouseWheel = Math.abs(delta) >= 120

            // Mouse wheel moves by standard 5% steps, touchpad moves much slower (e.g., 0.5%)
            let change = isMouseWheel ? 0.05 : 0.005
            let direction = delta > 0 ? 1 : -1
            
            root.volumeLevel = Math.max(0.0, Math.min(1.0, root.volumeLevel + (direction * change)))

            // Force Omarchy's bar to update the active tooltip text dynamically on scroll
            if (root.bar && typeof root.bar.showTooltip === "function") {
                root.bar.showTooltip(button, button.tooltipText)
            }
        }
    }
}