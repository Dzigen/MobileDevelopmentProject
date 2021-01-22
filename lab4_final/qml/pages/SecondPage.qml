import QtQuick 2.0
import Sailfish.Silica 1.0

Item {


    GridView {

        property int nameMax: -1
        property int nameMin: 1

        height: parent.height
        cellWidth: width / 7;
        cellHeight: cellWidth;
        visible: false

        cacheBuffer: 100

        model: ListModel {
            id: listmodel
        }

        delegate : Rectangle {
            width: parent.cellWidth
            height: parent.cellHeight
            border.color: "black"
            color: color1

            Text {
                anchors.centerIn: parent
                id: t
                color: "black"
                text: number1
            }
        }

        Component.onCompleted: {
            for(var j=0; j<7;j++){
                for(var i=0; i<42;i++){
                    nameMax++
                    listmodel.append({color1:"white",number1: nameMax})
                }
            }

            parent.anchors.top=row.bottom
            positionViewAtIndex(168,GridView.Beginning)
            listmodel.set(168,{color1:"red"})
        }

        onContentYChanged: {
            var index=indexAt(contentX,contentY)

            if(index<=126 && index!==1){
                positionViewAtIndex(126+42,GridView.Visible)

                for(var i=0; i<42;i++){
                    nameMin--
                    listmodel.insert(0,{color1:"white",number1: nameMin})
                }

                listmodel.set(126+42,{color1:"red"})

            }else if(index>=count-84){

                for(var j=0; j<42;j++){
                    nameMax--
                    listmodel.append({color1:"white",number1: nameMax})
                }

                listmodel.set(index,{color1:"red"})
            }
        }
    }
}
