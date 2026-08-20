import QtQuick
import qs.Ui

// https://gemini.google.com/app/e4a71ef5bc7fcd87

BarWidget {
    id: root
    moduleName: "opoii.clown"

    implicitWidth: button.implicitWidth
    implicitHeight: button.implicitHeight

    WidgetButton {
        id: button
        anchors.fill: parent
        bar: root.bar
        text: "🤡"
        active: ClownState.isPlaying
        
        tooltipText: {
            let volPercent = Math.round(ClownState.volumeLevel * 100)
            return ClownState.isPlaying ? "Stop (Vol: " + volPercent + "%)" : "Play (Vol: " + volPercent + "%)"
        }
        
        onPressed: function(b) {
            ClownState.toggle()
        }

        onWheelMoved: function(delta) {
            // 5% step is too high for touchpad gesture, so
            if (delta === 0) return
            
            // Mouse wheels report chunks of 120. Touchpads report smaller continuous values.
            let isMouseWheel = Math.abs(delta) >= 120

            // Mouse wheel moves by standard 5% steps, touchpad moves much slower (e.g., 0.5%)
            let change = isMouseWheel ? 0.05 : 0.005
            let direction = delta > 0 ? 1 : -1
            
            ClownState.volumeLevel = Math.max(0.0, Math.min(1.0, ClownState.volumeLevel + (direction * change)))

            // Force Omarchy's bar to update the active tooltip text dynamically on scroll
            if (root.bar && typeof root.bar.showTooltip === "function") {
                root.bar.showTooltip(button, button.tooltipText)
            }
        }
    }
}