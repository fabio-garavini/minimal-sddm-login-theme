import QtQuick 2.8
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.2
import QtQuick.Controls.Styles 1.4
import "components"


Rectangle {
    width: 640
    height: 480
    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    property int sizeAvatar: 130
    property int longitudMasLarga: 0
    TextConstants {
        id: textConstants
    }

    // hack for disable autostart QtQuick.VirtualKeyboard
    Loader {
        id: inputPanel
        property bool keyboardActive: false
        source: "components/VirtualKeyboard.qml"
    }
    FontLoader {
        id: fontbold
        source: "fonts/SFUIText-Semibold.otf"
    }
    Connections {
        target: sddm
        onLoginSucceeded: {

        }
        onLoginFailed: {
            password.placeholderText = textConstants.loginFailed
            password.placeholderTextColor = "white"
            password.text = ""
            password.focus = false
            errorMsgContainer.visible = true
        }
    }

    Image {
        id: wallpaper
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        visible: true
        Binding on source {
            when: config.background !== undefined
            value: config.background
        }

    }

    FastBlur {
        anchors.fill: wallpaper
        source: wallpaper
        radius: 32
    }

    BrightnessContrast {
        anchors.fill: wallpaper
        source: wallpaper
        brightness: 0
        contrast: 0.2
    }

    RowLayout {
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 40
        anchors.topMargin: 30

        spacing: 10

        ComboBox {
            id: session
            model: sessionModel
            textRole: "name"
            displayText: currentText
            font.pointSize: 10
            currentIndex: sessionModel.lastIndex

            width: 150
            height: 30

            background: Rectangle {
                implicitHeight: parent.height
                implicitWidth: parent.width
                color: "#222"
                opacity: 0.8
                radius: 10
            }

            delegate: MenuItem {
                id: menuitems
                width: slistview.width
                highlighted: session.highlightedIndex === index
                hoverEnabled: session.hoverEnabled

                contentItem: Text {
                    leftPadding: menuitems.indicator.width
                    rightPadding: menuitems.arrow.width
                    text: session.textRole ? (Array.isArray(session.model) ? modelData[session.textRole] : model[session.textRole]) : modelData
                    opacity: enabled ? 1.0 : 0.7
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    implicitWidth: menuitems.width
                    implicitHeight: menuitems.height
                    opacity: menuitems.highlighted ? 0.2 : 0
                    radius: 10
                    color: "#fff"
                }

                onClicked: {
                    ava.source = "/var/lib/AccountsService/icons/" + user.currentText
                    session.currentIndex = index
                    slistview.currentIndex = index
                    session.popup.close()
                }
            }

            indicator: Rectangle{
                anchors.right: parent.right
                anchors.rightMargin: 9
                height: parent.height
                width: 22
                color: "transparent"
                Image{
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: width
                    fillMode: Image.PreserveAspectFit
                    source: "images/conf.svg"
                }
            }

            contentItem: Text {
                leftPadding: kb.spacing
                rightPadding: session.indicator.width + session.spacing

                text: session.displayText
                font: session.font
                color: "#fff"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            popup: Popup {
                width: 250
                height: parent.height * menuitems.count
                implicitHeight: slistview.contentHeight
                margins: 0
                background: Rectangle {
                    implicitHeight: parent.height
                    implicitWidth: parent.width
                    color: "#222"
                    opacity: 1
                    radius: 10
                }
                contentItem: ListView {
                    id: slistview
                    clip: true
                    anchors.fill: parent
                    model: session.model
                    spacing: 0
                    highlightFollowsCurrentItem: true
                    currentIndex: session.highlightedIndex
                    delegate: session.delegate
                }
            }

        }

        ComboBox {
            id: kb
            model: keyboard.layouts
            displayText: currentValue.shortName
            font.pointSize: 10
            currentIndex: keyboard.currentLayout

            width: 100
            height: 30

            background: Rectangle {
                implicitHeight: parent.height
                implicitWidth: parent.width
                color: "#222"
                opacity: 0.8
                radius: 10
            }

            delegate: MenuItem {
                id: kbmenuitems
                width: kblistview.width
                highlighted: kb.highlightedIndex === index
                hoverEnabled: kb.hoverEnabled

                contentItem: Text {
                    leftPadding: kbmenuitems.indicator.width
                    rightPadding: kbmenuitems.arrow.width
                    text: modelData.shortName
                    opacity: enabled ? 1.0 : 0.7
                    color: "#ffffff"
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    implicitWidth: kbmenuitems.width
                    implicitHeight: kbmenuitems.height
                    opacity: kbmenuitems.highlighted ? 0.2 : 0
                    radius: 10
                    color: "#fff"
                }

                onClicked: {
                    kb.popup.close()
                }
            }

            indicator: Rectangle{
                anchors.right: parent.right
                anchors.rightMargin: 9
                height: parent.height
                width: 22
                color: "transparent"
                Image{
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width
                    height: width
                    fillMode: Image.PreserveAspectFit
                    source: "images/keyboard.svg"
                }
            }

            contentItem: Text {
                leftPadding: kb.spacing
                rightPadding: kb.indicator.width + kb.spacing

                text: kb.displayText
                font: kb.font
                color: "#fff"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                elide: Text.ElideRight
            }

            popup: Popup {
                width: 100
                height: parent.height * kbmenuitems.count
                implicitHeight: kblistview.contentHeight
                margins: 0
                background: Rectangle {
                    implicitHeight: parent.height
                    implicitWidth: parent.width
                    color: "#222"
                    opacity: 1
                    radius: 10
                }
                contentItem: ListView {
                    id: kblistview
                    clip: true
                    anchors.fill: parent
                    model: kb.model
                    spacing: 0
                    highlightFollowsCurrentItem: true
                    currentIndex: kb.highlightedIndex
                    delegate: kb.delegate
                }
            }

        }
    }

    Clock {
        id: clock
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 80
    }

    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40

        ListView {
            id: listuser
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 240
            model: userModel
            height: userModel.count*(sizeAvatar*.9)
            verticalLayoutDirection : ListView.TopToBottom
            orientation: ListView.vertical
            currentIndex: userModel.lastIndex
            spacing: 10
            visible : false
            delegate: Item {
                id: delegate_
                width: sizeAvatar*.9
                height: sizeAvatar*.9
                anchors.horizontalCenter: parent.horizontalCenter

                Image {
                    source: model.icon
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource:  Rectangle {
                            width: sizeAvatar
                            height: sizeAvatar
                            radius: height/2
                        }
                    }
                }
                Rectangle {
                    id: resalt
                    color: "#00a86b"
                    width: delegate_.width/3.5
                    height: width
                    radius: width/2
                    border.color: "white"
                    border.width: width/14
                    visible: index === userModel.lastIndex
                    anchors.top: parent.top
                    anchors.right: parent.right
                    Image {
                        id: palomita
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width*.6
                        height: width
                        source: "images/palomita.svg"
                        sourceSize: Qt.size(width, width)
                        fillMode: Image.PreserveAspectFit
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
                Text {
                    text: model.name
                    color: "#fff"
                    font.bold: true
                    font.pixelSize: sizeAvatar/6
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: delegate_.width+10
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        user.currentIndex = index
                        ava.source = "/var/lib/AccountsService/icons/" + user.currentText
                        listuser.visible = false
                        ava.visible = true
                        userModel.lastIndex = index
                    }
                }
            }
        }

        DropShadow {
            anchors.fill: ava
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: usernametext.top
            anchors.bottomMargin: 20
            horizontalOffset: 0
            verticalOffset: 0
            radius: 15.0
            samples: 15
            color: "#50000000"
            source: mask
            visible: listuser.visible ? false : true
        }

        Image {
            id: ava
            width: sizeAvatar
            height: sizeAvatar
            visible: true
            fillMode: Image.PreserveAspectCrop
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: usernametext.top
            anchors.bottomMargin: 20
            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: mask
            }
            source: "/var/lib/AccountsService/icons/" + user.currentText
            onStatusChanged: {
                if (status == Image.Error) return source = "images/avatar.png"
            }
            MouseArea {
                anchors.fill: ava
                onClicked: {
                    listuser.visible = true
                    ava.visible = false
                }
            }
        }

        Rectangle {
            id: mask
            width: sizeAvatar
            height: sizeAvatar
            radius: sizeAvatar/2
            visible: false
        }

        // Custom ComboBox for hack colors on DropDownMenu
        ComboBox {
            id: user
            height: 40
            width: 226
            textRole: "name"
            currentIndex: userModel.lastIndex
            model: userModel
            visible: false
        }
        Text {
            id: usernametext
            text: user.currentText
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: password.top
            anchors.bottomMargin: 30
            font.pixelSize: 20
            font.family: fontbold.name
            font.capitalization: Font.Capitalize
            font.weight: Font.DemiBold
            visible: listuser.visible ? false : true
            color: "#fff"
            layer.enabled: true
                layer.effect: DropShadow {
                horizontalOffset: 1
                verticalOffset: 1
                radius: 10
                samples: 25
                color: "#26000000"
            }
        }
        TextField {
            id: password
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: powerButtons.top
            anchors.bottomMargin: 60
            height: 32
            width: 250
            color: "#fff"
            echoMode: TextInput.Password
            focus: true
            placeholderText: textConstants.password
            horizontalAlignment: TextInput.AlignHCenter
            visible: listuser.visible ? false : true

            onAccepted: sddm.login(user.currentText, password.text, session.currentIndex)

            background: Rectangle {
                implicitWidth: parent.width
                implicitHeight: parent.height
                color: keyboard.capsLock ? "#FF0000" : "#222"
                opacity:keyboard.capsLock ? 0.5 :  0.2
                radius: 15
            }

            Image {
                id: caps
                width: 24
                height: 24
                opacity: 0
                state: keyboard.capsLock ? "activated" : ""
                anchors.right: password.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 10
                fillMode: Image.PreserveAspectFit
                source: "images/capslock.svg"
                sourceSize.width: 24
                sourceSize.height: 24

                states: [
                    State {
                        name: "activated"
                        PropertyChanges {
                            target: caps
                            opacity: 1
                        }
                    },
                    State {
                        name: ""
                        PropertyChanges {
                            target: caps
                            opacity: 0
                        }
                    }
                ]

                transitions: [
                    Transition {
                        to: "activated"
                        NumberAnimation {
                            target: caps
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: imageFadeIn
                        }
                    },

                    Transition {
                        to: ""
                        NumberAnimation {
                            target: caps
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: imageFadeOut
                        }
                    }
                ]
            }
        }

        RowLayout {
            id: powerButtons
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 20

            height: 50
            spacing: 40

            Item {
                width: parent.height
                height: parent.height

                Rectangle {
                    id: shutdown
                    width: parent.height
                    height: parent.height
                    color: "#222"
                    opacity: 0
                    radius: 10
                }

                Image {
                    height: parent.height -10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "images/system-shutdown.svg"
                    fillMode: Image.PreserveAspectFit
                    sourceSize: Qt.size(parent.height-10, parent.height-10)
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onExited: {
                        shutdown.opacity = 0
                    }
                    onEntered: {
                        shutdown.opacity = 0.2
                    }
                    onClicked: {
                        shutdown.opacity = 0.4
                        sddm.powerOff()
                    }
                }
            }

            Item {
                width: parent.height
                height: parent.height

                Rectangle {
                    id: reboot
                    width: parent.height
                    height: parent.height
                    color: "#222"
                    opacity: 0
                    radius: 10
                }

                Image {
                    height: parent.height -10
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter

                    source: "images/system-reboot.svg"
                    fillMode: Image.PreserveAspectFit
                    sourceSize: Qt.size(parent.height-10, parent.height-10)
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onExited: {
                        reboot.opacity = 0
                    }
                    onEntered: {
                        reboot.opacity = 0.2
                    }
                    onClicked: {
                        reboot.opacity = 0.4
                        sddm.reboot()
                    }
                }
            }
        }



        Keys.onPressed: {
            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                sddm.login(user.currentText, password.text, session.currentIndex)
                event.accepted = true
            }
        }

        // Custom ComboBox for hack colors on DropDownMenu

    }

}