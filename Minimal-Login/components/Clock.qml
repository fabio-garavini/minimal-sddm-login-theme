import QtQuick 2.8
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5
import org.kde.plasma.core 2.0

ColumnLayout {
    spacing: 2

    FontLoader {
        id: fontbold
        source: "../fonts/SFUIText-Semibold.otf"
    }
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software
    Label {
        text: Qt.formatDateTime(new Date(), "dddd, MMMM d")
        color: "white"
        opacity: 0.5
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 20
        font.weight: Font.DemiBold
        font.capitalization: Font.Capitalize
        Layout.alignment: Qt.AlignHCenter
        font.family: fontbold.name

    }
    Label {
        text: Qt.formatDateTime(new Date(), "HH:mm")
        color: "white"
        opacity: 0.5
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 100
        font.bold: true
        Layout.alignment: Qt.AlignHCenter
        font.family: fontbold.name

    }

}