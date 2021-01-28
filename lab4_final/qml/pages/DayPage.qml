import QtQuick 2.0
import Nemo.Notifications 1.0
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1

Item {

    function check(){
        console.log("s")
    }

    Rectangle{
        id:firstArea
        anchors.fill:parent
        color: "yellow"

        Rectangle{
            id:clockRect
            anchors.centerIn: parent
            color: "black"
            width: parent.width/2
            height: width
            radius: width
            TimePicker {
                id:clock
                anchors.fill: parent
                hour: 13
                minute: 30
            }
        }

        Rectangle{
            id:rect
            color: "black"
            width: clockRect.width
            height: clockRect.width/4
            anchors.top: clockRect.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                color: "white"
                anchors.centerIn: parent
                id: time
                text: clock.timeText
            }
        }

        Button {
            width: clockRect.width
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: rect.bottom
            anchors.topMargin: 20
            color: "black"
            Notification {
                id: notification
                timestamp: new Date(year,month,day,clock.hour,clock.minute)

                summary: "Notification summary"
                body: "Notification body"
                onClicked: console.log("Clicked")
            }
            text: "Application notification" + (notification.replacesId ? " ID:" + notification.replacesId : "")
            onClicked: notification.publish()

        }
    }
}
