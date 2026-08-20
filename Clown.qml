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

        // Overlay a MouseArea just for capturing scroll events over the button
        MouseArea {
            anchors.fill: parent
            // Let click/press events fall through to the WidgetButton below
            acceptedButtons: Qt.NoButton 
            
            onWheel: function(wheel) {
                // Determine step direction from angleDelta (positive = scroll up, negative = scroll down)
                let delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05
                
                // Adjust and clamp volume between 0.0 and 1.0
                root.volumeLevel = Math.max(0.0, Math.min(1.0, root.volumeLevel + delta))
                
                // Force Omarchy's bar to update the active tooltip text dynamically on scroll
                if (root.bar && typeof root.bar.showTooltip === "function") {
                    root.bar.showTooltip(button, button.tooltipText)
                }
            }
        }
    }
}