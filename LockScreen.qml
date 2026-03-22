import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

Rectangle {
    id: root
    width: 480
    height: 854
    color: "transparent"

    // ── Background ──────────────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: "#1a1a2e"

        // Geometric polygon layers (mimic the dark angular wallpaper)
        Canvas {
            anchors.fill: parent
            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)

                // Large top-left triangle
                ctx.beginPath()
                ctx.moveTo(0, 0)
                ctx.lineTo(width * 0.65, 0)
                ctx.lineTo(0, height * 0.55)
                ctx.closePath()
                ctx.fillStyle = "#22243a"
                ctx.fill()

                // Centre diamond / facet
                ctx.beginPath()
                ctx.moveTo(width * 0.25, 0)
                ctx.lineTo(width, height * 0.35)
                ctx.lineTo(width * 0.6, height * 0.75)
                ctx.lineTo(0, height * 0.4)
                ctx.closePath()
                ctx.fillStyle = "#2d2f4a"
                ctx.fill()

                // Bottom-right triangle
                ctx.beginPath()
                ctx.moveTo(width * 0.5, height)
                ctx.lineTo(width, height * 0.5)
                ctx.lineTo(width, height)
                ctx.closePath()
                ctx.fillStyle = "#1e2038"
                ctx.fill()

                // Highlight facet (lighter silver-ish)
                ctx.beginPath()
                ctx.moveTo(width * 0.3, height * 0.1)
                ctx.lineTo(width * 0.75, height * 0.05)
                ctx.lineTo(width * 0.55, height * 0.45)
                ctx.lineTo(width * 0.15, height * 0.38)
                ctx.closePath()
                ctx.fillStyle = "#383a5a"
                ctx.fill()

                // Extra small facets for depth
                ctx.beginPath()
                ctx.moveTo(width * 0.55, height * 0.45)
                ctx.lineTo(width * 0.85, height * 0.38)
                ctx.lineTo(width, height * 0.55)
                ctx.lineTo(width * 0.7, height * 0.65)
                ctx.closePath()
                ctx.fillStyle = "#2a2c48"
                ctx.fill()
            }
        }
    }

    // ── Clock & Date ─────────────────────────────────────────────────────────
    Column {
        id: clockColumn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 72
        spacing: 6

        // Time
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            Text {
                id: timeText
                font.family: "sans-serif"
                font.pixelSize: 80
                font.weight: Font.Bold
                color: "#ffffff"
                renderType: Text.NativeRendering
            }

            Text {
                id: ampmText
                font.family: "sans-serif"
                font.pixelSize: 28
                font.weight: Font.Normal
                color: "#cccccc"
                anchors.bottom: timeText.bottom
                anchors.bottomMargin: 12
            }
        }

        // Date
        Text {
            id: dateText
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "sans-serif"
            font.pixelSize: 20
            color: "#4da6ff"
            font.weight: Font.Medium
        }
    }

    // ── Timer ─────────────────────────────────────────────────────────────────
    Timer {
        id: clockTimer
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            var now = new Date()

            var hours = now.getHours()
            var minutes = now.getMinutes()
            var ampm = hours >= 12 ? "PM" : "AM"
            hours = hours % 12
            if (hours === 0) hours = 12
            var minStr = minutes < 10 ? "0" + minutes : "" + minutes

            timeText.text = hours + ":" + minStr
            ampmText.text = ampm

            var days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
            var months = ["January","February","March","April","May","June",
                          "July","August","September","October","November","December"]
            dateText.text = days[now.getDay()] + ", " + months[now.getMonth()] + " " + now.getDate()
        }
    }

    // ── Notification Cards ────────────────────────────────────────────────────
    Column {
        id: notificationsColumn
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: clockColumn.bottom
        anchors.topMargin: 60
        width: parent.width - 48
        spacing: 10

        // Generic notification card component via Repeater
        Repeater {
            model: ListModel {
                ListElement {
                    appName: "Mail"
                    message: "You have 3 new messages"
                    timeAgo: "2m ago"
                    iconPath: "mail"
                }
                ListElement {
                    appName: "Messages"
                    message: "Hey! Are we still on for tonight?"
                    timeAgo: "5m ago"
                    iconPath: "chat"
                }
                ListElement {
                    appName: "Calendar"
                    message: "Meeting in 30 minutes"
                    timeAgo: "10m ago"
                    iconPath: "calendar"
                }
            }

            delegate: Rectangle {
                width: notificationsColumn.width
                height: 72
                radius: 16
                color: Qt.rgba(0, 0, 0, 0.45)

                // Frosted-glass border
                border.color: Qt.rgba(1, 1, 1, 0.08)
                border.width: 1

                Row {
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 16
                    anchors.right: parent.right
                    anchors.rightMargin: 16
                    spacing: 14

                    // App icon background
                    Rectangle {
                        width: 40
                        height: 40
                        radius: 10
                        color: Qt.rgba(0.18, 0.47, 0.85, 0.85)
                        anchors.verticalCenter: parent.verticalCenter

                        Canvas {
                            anchors.fill: parent
                            property string icon: iconPath

                            onPaint: {
                                var ctx = getContext("2d")
                                ctx.clearRect(0, 0, width, height)
                                ctx.strokeStyle = "#ffffff"
                                ctx.lineWidth = 2
                                ctx.lineCap = "round"
                                ctx.lineJoin = "round"

                                if (icon === "mail") {
                                    // Envelope outline
                                    ctx.beginPath()
                                    ctx.rect(8, 12, 24, 16)
                                    ctx.stroke()
                                    ctx.beginPath()
                                    ctx.moveTo(8, 12)
                                    ctx.lineTo(20, 22)
                                    ctx.lineTo(32, 12)
                                    ctx.stroke()
                                } else if (icon === "chat") {
                                    // Speech bubble
                                    ctx.beginPath()
                                    ctx.roundRect(7, 8, 24, 18, 4)
                                    ctx.stroke()
                                    ctx.beginPath()
                                    ctx.moveTo(12, 26)
                                    ctx.lineTo(10, 32)
                                    ctx.lineTo(18, 26)
                                    ctx.stroke()
                                } else if (icon === "calendar") {
                                    // Calendar grid
                                    ctx.beginPath()
                                    ctx.rect(8, 10, 24, 20)
                                    ctx.stroke()
                                    ctx.beginPath()
                                    ctx.moveTo(8, 16)
                                    ctx.lineTo(32, 16)
                                    ctx.stroke()
                                    ctx.beginPath()
                                    ctx.moveTo(14, 8)
                                    ctx.lineTo(14, 14)
                                    ctx.stroke()
                                    ctx.beginPath()
                                    ctx.moveTo(26, 8)
                                    ctx.lineTo(26, 14)
                                    ctx.stroke()
                                }
                            }
                        }
                    }

                    // Text block
                    Column {
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: 3
                        width: parent.width - 54 - 60

                        Text {
                            text: appName
                            font.family: "sans-serif"
                            font.pixelSize: 15
                            font.weight: Font.DemiBold
                            color: "#ffffff"
                        }
                        Text {
                            text: message
                            font.family: "sans-serif"
                            font.pixelSize: 13
                            color: "#bbbbbb"
                            elide: Text.ElideRight
                            width: parent.width
                        }
                    }

                    Item { Layout.fillWidth: true; width: 1 }

                    Text {
                        text: timeAgo
                        font.family: "sans-serif"
                        font.pixelSize: 12
                        color: "#888888"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }
    }

    // ── Slide to Unlock ───────────────────────────────────────────────────────
    Rectangle {
        id: unlockBar
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 48
        width: parent.width - 48
        height: 60
        radius: 30
        color: Qt.rgba(0, 0, 0, 0.35)
        border.color: Qt.rgba(1, 1, 1, 0.12)
        border.width: 1

        // Drag handle / arrow button
        Rectangle {
            id: handle
            x: 6
            anchors.verticalCenter: parent.verticalCenter
            width: 48
            height: 48
            radius: 24
            color: "#3b82f6"

            Text {
                anchors.centerIn: parent
                text: "›"
                font.pixelSize: 28
                font.weight: Font.Bold
                color: "#ffffff"
            }

            // Simple drag behaviour
            MouseArea {
                anchors.fill: parent
                drag.target: handle
                drag.axis: Drag.XAxis
                drag.minimumX: 6
                drag.maximumX: unlockBar.width - handle.width - 6

                onReleased: {
                    if (handle.x > unlockBar.width * 0.55) {
                        unlockAnimation.start()
                    } else {
                        resetAnimation.start()
                    }
                }
            }

            NumberAnimation {
                id: resetAnimation
                target: handle
                property: "x"
                to: 6
                duration: 250
                easing.type: Easing.OutCubic
            }

            NumberAnimation {
                id: unlockAnimation
                target: handle
                property: "x"
                to: unlockBar.width - handle.width - 6
                duration: 200
                easing.type: Easing.OutCubic
                onFinished: {
                    // In a real shell, emit unlock signal here
                    console.log("Device unlocked")
                    resetAnimation.start()
                }
            }
        }

        Text {
            anchors.centerIn: parent
            text: "Slide to Unlock"
            font.family: "sans-serif"
            font.pixelSize: 16
            color: "#cccccc"
            font.letterSpacing: 0.5
        }
    }
}
