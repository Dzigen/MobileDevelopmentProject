import QtQuick 2.0
import Sailfish.Silica 1.0
import QtQuick.Layouts 1.1

Page{

    allowedOrientations: Orientation.All

    function getYear(offset){
        var today = new Date();
        var year = today.getFullYear();
        return (year + offset)
    }

    function blankDays(month, year){
        var days= new Date(year, month).getDay()
        return days === 0 ? 6 : days-1
    }

    function daysInMonth (month, year) {
        return 32 - new Date(year,month,32).getDate()
    }

    function getName(idx){
        const monthNames = ["Январь", "Февраль", "Март", "Апрель", "Май", "Июнь",
                            "Июль", "Август", "Сентабрь", "Октябрь", "Ноябрь", "Декабрь"];
        return monthNames[idx]
    }

    property int maxYear: getYear(2)
    property int minYear: getYear(-6)

    property int yearPos: 6

    property int year: getYear(0)
    property int month: new Date().getMonth()
    property int day: new Date().getDate()

    property int curYear: getYear(0)
    property int curMonth: new Date().getMonth()
    property int curDay: new Date().getDate()

    property bool flag: true

    /*Календарь по годам*/
    ListView {
        id: listView1
        anchors.top: row.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        cacheBuffer: 4

        signal signal5()

        delegate: Item {
            id: item
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.width*4

            Rectangle {
                anchors.fill: parent

                /*Год календаря*/
                Text {
                    id: name
                    text: idshnik
                    font.pixelSize: 50
                    font.weight:"Black"
                    color: clr
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width/14
                }

                /*Месяцы текущего года*/
                Grid{
                    anchors.top: name.bottom
                    anchors.topMargin: 30
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    columns: 2
                    spacing: 2

                    Repeater {
                        id:repeater

                        model: 12

                        Rectangle {
                            id: areas
                            width: parent.width/2; height: width*1.25
                            border.width: 1
                            color: "yellow"

                            MouseArea{
                                anchors.fill: parent
                                onClicked: {year=name.text; minYear=year-6; maxYear=year+2; month=index; box.centerButPressed();}
                            }

                            Text {
                                id: monthName
                                font.weight:"Bold"
                                text: getName(index)
                                font.pointSize: 25
                                anchors.top: parent.top
                                anchors.left: parent.left
                                anchors.leftMargin: 5
                            }

                            /*Обозначения дней недели*/
                            Grid {
                                id: weeksLetters
                                columns: 7
                                spacing: parent.width/10
                                anchors.top: monthName.bottom
                                anchors.topMargin: 40
                                anchors.horizontalCenter: parent.horizontalCenter

                                Repeater{
                                    model:7

                                    Rectangle{
                                        width: 10
                                        height: 10
                                        color: "yellow"

                                        function signWeek(){
                                            const letters=["П","В","С","Ч","П","С","В"]
                                            return letters[index]
                                        }

                                        Text {
                                            id: dayOftheWeek
                                            text: signWeek()
                                            anchors.centerIn: parent
                                        }
                                    }
                                }
                            }

                            /*Сетка дней текущего месяца*/
                            Grid{
                                id:gd
                                columns: 7
                                spacing: parent.width/20
                                anchors.top: weeksLetters.bottom
                                anchors.topMargin: 40
                                anchors.horizontalCenter: parent.horizontalCenter

                                Repeater{
                                    id:days

                                    property int blank: blankDays(index,parseInt(name.text,10))
                                    property int month: index

                                    model: daysInMonth(index,parseInt(name.text,10)) + blankDays(index,parseInt(name.text,10))

                                    Rectangle{

                                        width: 30
                                        height: 30

                                        function curDate(){

                                            if(index+1>days.blank){
                                                var date=new Date();
                                                var year=date.getFullYear();
                                                var month=date.getMonth();
                                                var day=date.getDate();

                                                if (year===parseInt(name.text,10) && days.month===month && index+1-days.blank===day){
                                                    return "red"
                                                }else{
                                                    return "yellow"
                                                }

                                            }else{
                                                return "yellow"
                                            }
                                        }

                                        color: curDate()

                                        Text {
                                            anchors.centerIn: parent
                                            color: "black"
                                            text: index+1>days.blank ? index+1-days.blank : ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        model: ListModel {
            id: listModel
        }

        function changeIndex(){
            positionViewAtIndex(5, ListView.Beginning)
        }

        function checkYear(index){
            if(index!==-1){
                var prevYear=year
                var indx=0
                year=listModel.get(index).idshnik
                if(year-prevYear>0){
                    indx=index-1;
                }else if(year-prevYear<0){
                    indx=index+1
                }else{
                    return
                }

                if(prevYear===curYear)
                    listModel.set(indx,{clr:"red"})
                else
                    listModel.set(indx,{clr:"black"})

                listModel.set(index,{clr:"white"})
            }

            return
        }



        /*Реализация "бесконечного скрола" ленты календаря*/
        onContentYChanged: {
            var index=indexAt(contentX,contentY)
            checkYear(index)

            if(index>(count-3) ){
                maxYear++
                listModel.append({idshnik:maxYear, clr: maxYear==curYear ? "red" : "black"})
                listModel.remove(0)
                minYear++
            }else if(index===4 ){
                changeIndex()
                flag=false;
                minYear--
                listModel.insert(0,{idshnik:Math.abs(minYear),clr: maxYear==curYear ? "red" : "black"})
                listModel.remove(count-1)
                maxYear--
            }
        }

        onSignal5: {
            listModel.clear();
            for(var i=0;i<9;i++){
                listModel.append({idshnik:minYear+i,clr: minYear+i==curYear ? "red" : "black"})
            }

            listModel.set(yearPos,{clr:"white"})
            positionViewAtIndex(yearPos, ListView.Beginning)

        }

        Component.onCompleted: {
            signal5()
        }
    }




    ListModel{
        id:monthsProperties
    }

    /*Календарь по месяцам*/
    Rectangle{
        id:gridBack
        color: "white"
        anchors.top: weeks.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: false

        GridView {
            id: grid
            anchors.fill: parent
            property int nameMax: 0
            property int nameMin: 1
            signal signal4()

            cacheBuffer: 65

            height: parent.height
            cellWidth: width / 7;
            cellHeight: cellWidth;

            model: ListModel {
                id: listmodel2
            }

            delegate : Rectangle {
                width: grid.cellWidth
                height: grid.cellHeight
                border.color: "black"
                color: color1

                Text {
                    anchors.centerIn: parent
                    id: shortNameMonth
                    text: name1
                    color: "black"
                }

                Rectangle{
                    anchors.top: parent.top
                    anchors.topMargin: parent.border.width
                    anchors.right: parent.right
                    anchors.rightMargin: parent.border.width
                    width: parent.width/3
                    height: width

                    color: color2
                    Text {
                        anchors.centerIn: parent
                        id: t
                        color: "black"
                        text: number1
                    }
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if(t.text!=""){

                            for(var j=0;j<monthsProperties.count;j++){
                                if(index>=monthsProperties.get(j).startIndex &&
                                        index<monthsProperties.get(j).startIndex+monthsProperties.get(j).sumElements){

                                    var trueDay=index-monthsProperties.get(j).startIndex
                                    var newMon=monthsProperties.get(j).month

                                    grid.changeYear(month,newMon)

                                    month=monthsProperties.get(j).month
                                    day=(trueDay+1-blankDays(month,year));

                                    break
                                }
                            }

                            box.rightButPressed();
                        }
                    }
                }
            }

            function checkBlanksColor(leftBoard,rightBoard,pos){
                return pos+1>leftBoard && pos+1<=rightBoard ? "yellow" : "#daa520"
            }


            function getShortMonthName(idx){
                const monthNames = ["Янв.", "Февр.", "Март", "Апр.", "Май", "Июнь",
                                    "Июль", "Авг.", "Сент.", "Окт.", "Нояб.", "Дек."];
                return monthNames[idx]
            }

            onSignal4:{
                listmodel2.clear();
                monthsProperties.clear()

                var curIndexStart=0
                var buf=0

                for(var j=0; j<7; j++){
                   if((j-3)===0){
                       curIndexStart=buf
                   }

                   buf=createNewGridMonth(month-3+j,year,j,buf)
                }
                console.log("[начало]"+month)
                positionViewAtIndex(curIndexStart-21,GridView.Beginning)
                console.log("[конец]"+month)
            }

            function createNewGridMonth(mon,yr,where,startPos){
                var curMon=mon
                var curYr=yr

                if(curMon<0){
                    curYr-=1
                    curMon=12+curMon
                }else if(curMon>11){
                    curMon-=12
                    curYr+=1
                }

                var days=daysInMonth(curMon,curYr)
                var blanksFront=blankDays(curMon,curYr)
                var blanksEnd=7-(days+blanksFront)%7

                var sum=blanksFront+days+blanksEnd

                monthsProperties.insert(where,{startIndex:startPos, sumElements: sum, month:curMon, year:curYr })

                var flag=false
                var flag2=false
                var flag3=true

                for(var i=0; i<sum;i++){
                    if(i+1>blanksFront && i+1<=blanksFront+days){
                        if(flag3){
                            flag3=false
                            flag2=true
                        }

                        flag=true
                    }

                    listmodel2.insert(i+startPos,{color1:checkBlanksColor(blanksFront,blanksFront+days,i),
                                          color2:curYr===curYear && curMon===curMonth && (i+1-blanksFront)==curDay ? "red" : checkBlanksColor(blanksFront,blanksFront+days,i),
                                          number1: flag===true ? (i+1-blanksFront).toString() : "",
                                          name1: flag2===true && where!==3 ? getShortMonthName(curMon) : ""
                                      })

                    flag=false
                    flag2=false

                }
                return startPos+sum
            }

            function deleteGridMonth(indx){
                listmodel2.remove(monthsProperties.get(indx).startIndex, monthsProperties.get(indx).sumElements)
                var value=monthsProperties.get(indx).sumElements
                monthsProperties.remove(indx)

                return value
            }


            function changeMonthYear(nxt){

                var blanksFront=blankDays(monthsProperties.get(3).month,monthsProperties.get(3).year)
                var nameMon=getShortMonthName(monthsProperties.get(3).month)
                listmodel2.get(monthsProperties.get(3).startIndex+blanksFront).name1=nameMon

                blanksFront=blankDays(monthsProperties.get(nxt).month,monthsProperties.get(nxt).year)
                listmodel2.get(monthsProperties.get(nxt).startIndex+blanksFront).name1=""
                console.log("here_1")
                month=monthsProperties.get(nxt).month

                changeYear(monthsProperties.get(3).month,month)
            }

            function changeYear(cur,nxt){
                var difMons=cur-nxt
                if(Math.abs(difMons)!=1){
                    if(difMons>0){
                        year+=1
                        minYear+=1
                        maxYear+=1
                    }else if(difMons<0){
                        year-=1
                        minYear-=1
                        maxYear-=1
                    }
                }
            }

            property bool f: true
            onContentYChanged: {
                var i=indexAt(contentX,contentY)
                console.log(i)
                var buf=0



                if(i<monthsProperties.get(2).startIndex-14 && f && i!==0){

                    f=false

                    console.log("here_3")
                    changeMonthYear(2)

                    var mon1=monthsProperties.get(0).month
                    var yr1=monthsProperties.get(0).year

                    deleteGridMonth(monthsProperties.count-1)

                    buf=createNewGridMonth(mon1-1,yr1,0,0)

                    for(var j=1;j<monthsProperties.count;j++){
                        monthsProperties.get(j).startIndex+=buf

                    }

                    f=true

                }else if(i>=(monthsProperties.get(4).startIndex-21) && f){

                    f=false

                    console.log("here_4")
                    changeMonthYear(4)

                    var mon=monthsProperties.get(monthsProperties.count-1).month
                    var yr=monthsProperties.get(monthsProperties.count-1).year
                    var st=monthsProperties.get(monthsProperties.count-1).startIndex+monthsProperties.get(monthsProperties.count-1).sumElements

                    createNewGridMonth(mon+1,yr,monthsProperties.count,st)
                    buf=deleteGridMonth(0)

                    for(j=0;j<monthsProperties.count;j++){
                        monthsProperties.get(j).startIndex-=buf

                    }

                    f=true
                }
            }
        }
    }

    /*Календарь по дням*/
    DayPage{
        id:daypage
        anchors.top: row.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: parent.height
        visible: false

    }

    /*Табличка с днями недели*/
    Grid{
        id:weeks
        columns: 7
        height: row.height/2
        width: parent.width
        anchors.top: row.verticalCenter
        anchors.topMargin: row.height/3
        visible: false

        Repeater{
            model:7

            Rectangle{
                width: parent.width/7
                color: "black"
                height: parent.height

                function signWeek(){
                    const letters=["Пн","Вт","Ср","Чт","Пн","Сб","Вс"]
                    return letters[index]
                }

                function specificIndex(){
                    return index===6 ? 0 : index+1
                }

                function checkCurDate(){
                    return year===curYear && month===curMonth && day===curDay ? true : false
                }

                function checkCurDay(){
                    return daypage.visible==true && new Date(year,month,day).getDay()===specificIndex() ? true : false
                }

                Text {
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height/15
                    anchors.right: parent.right
                    color: checkCurDay() && checkCurDate() ? "red" : "white"
                    text: checkCurDay() ? day+","+signWeek() : signWeek()
                }
            }
        }
    }

    /*Верхнее меню*/
    Rectangle {
        id:row
        anchors.top: parent.top
        width: parent.width
        height: parent.height/8
        color: "black"

        /*Текущий год и месяц*/
        Column{
            spacing: 10

            anchors.left: parent.left
            anchors.leftMargin: parent.width/15
            anchors.top: parent.top
            anchors.topMargin: parent.height/4
            Text{
                text: year

                font.pixelSize: 50
                font.weight: "Black"
                color: year==curYear ? "red" : "white"
            }

            Text {
                id: mthName
                font.pixelSize: 30
                font.weight: "Bold"
                text: getName(month)
                color: month==curMonth && year==curYear ? "red" : "white"
                visible: false
            }
        }



        /*Переключатель между видами календаря*/
        Box{
            id:box
            anchors.centerIn: parent
            width: parent.width/2
            height: parent.height/2

            onSignal1: {listView1.signal5(); gridBack.visible=false; listView1.visible=true; mthName.visible=false; daypage.visible=false; weeks.visible=false}
            onSignal2: {grid.signal4(); gridBack.visible=true; mthName.visible=true; listView1.visible=false; daypage.visible=false; weeks.visible=true}
            onSignal3: {gridBack.visible=false;console.log(day+" "+month+" "+year); listView1.visible=false; mthName.visible=true; daypage.visible=true; weeks.visible=true}
        }
    }
}
