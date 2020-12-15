import QtQuick 2.12
import Felgo 3.0
import "model"

//import QtQuick.Controls 1.4

import QtQuick.Controls 2.4



import QtQuick.Layouts 1.11
FlickablePage {
    title: "Digital Shop Evidencias"

    id : thisPage


    //property var  myData: null

    property var numOption : 0

    readonly property real contentPadding: dp(Theme.navigationBar.defaultBarItemPadding) // use theme setting for padding, aligns content with navigation bar items

    property bool acceptableInput : true ; // textInput.acceptableInput





    Component.onCompleted: {
        console.log( "Al Cargar = " + dataModel.dataSelected )
        //myData = JSON.parse(dataModel.dataSelected)


    }

    onPushed: {

        myCombo.model = ["Seleccione Evidencia","Punto de Venta","Inventario" ,
                "Producto Dañado" , "Documento Venta" , "Documento Devolucion" ] ;

    }



    Column {

        topPadding: 200

        AppTextField{
            id: textEdit
            anchors.horizontalCenter: parent.horizontalCenter
            width: dp(400)
            placeholderText: "Observaciones ..."
            //anchors.centerIn: parent


            font.pixelSize: sp(14)
            borderColor: Theme.tintColor
            borderWidth: !Theme.isAndroid ? dp(2) : 0
          }



            ComboBox {

                id : myCombo

                currentIndex: 0

                font.pixelSize: 30

                //displayText: "Seleccione Repercusión"


                anchors.horizontalCenter: parent.horizontalCenter

                model: []
                width: 600

                height: 100

                onActivated: {

                }




            }







        GridLayout{

            columns: 2
            rows: 2



            id : myGrid


            anchors.horizontalCenter: parent.horizontalCenter


            layoutDirection: Qt.LeftToRight





             AppButton{
                id: calificar2
                text: qsTr("Foto para evidencia")

                onClicked: {

                    if ( myCombo.currentIndex === 0 )
                    {
                        nativeUtils.displayMessageBox("Favor de selecciona calificaión válida",   "", 1)
                        return ;
                    }
                    console.log( "edit = " + textEdit.text)





                    var lect = {}

                    lect.califica = myCombo.currentIndex ;
                    lect.observaciones = textEdit.text
                    logic.setObservaCalifica( lect )

                    thisPage.navigationStack.push(myCamera)




                }


                width: 100
                height: 100

            }

             AppButton{
                id: calificar4

                width: 100
                height: 100
                text: qsTr("Enviar")

                onClicked: {
                    console.log("Datos enviados al servidor") ;

                    if ( dataModel.numEvidencias === 0 )
                    {
                        numOption = 0

                        nativeUtils.displayMessageBox("No se tienen evidencias", "No de puede cerrar servicio", 1)


                        return
                    }



                    var strNumEvidencias = "Tiene " + dataModel.numEvidencias + " evidencias"

                    numOption = 1

                    nativeUtils.displayMessageBox("Esta seguro de terminar este servicico???", strNumEvidencias, 2)


                    console.log( "Datos recibidos en el servidor") ;
                }

            }



        }

        Connections {

            target: nativeUtils

            // this signal has the parameter accepted, telling if the Ok button was clicked
            onMessageBoxFinished: {

                if ( numOption === 0 )
                {
                    return ;
                }

                if ( numOption === 1 )
                {

                    if ( accepted === true )
                    {
                        console.debug("Procedemos a cerrar la asignacion")

                        logic.setClearEvidencias()


                        myProcesar.removeLast()

                        myProcesar.loadJsonData()
                        if ( navigationStack.contains(OReady2) === true )
                        {
                             myProcesadas.loadJsonData()
                        }

                        navigationStack.popAllExceptFirst()

                    }
                    else
                    {
                        console.debug("No cerraremos la asignacion")
                    }

                }

                if ( numOption === 2 )
                {
                    if ( accepted === true )
                    {
                        logic.setCalificaSelected( myCombo.currentIndex + 1 )
                        thisPage.navigationStack.push(myCamera)
                        //console.debug("Antes de display camera")

                        //nativeUtils.displayCameraPicker("test")
                        //app.displayCamera() ;
                        //myCamera.app.displayCamera()
                    }
                }

            }
        }



    }



    Component{
        id :myCamera

        CameraDigital{}

    }


}

