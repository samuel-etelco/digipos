import QtQuick 2.0
import Felgo 3.0

//import QtQuick.Controls 2.5
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.11

FlickablePage {
    id: pedidosEntry

    title: qsTr("Digital Pos ... Solicita Producto")

    backgroundColor: Qt.rgba(0,0,0, 0.75) // page background is translucent, we can see other items beneath the page
    useSafeArea: false // do not consider safe area insets of screen


    property var myData: null

    Component.onCompleted: {

        console.log( "indexOrder = " + dataModel.indexOrder )

        //myData = dataModel.body[dataModel.indexOrder]

        myData = dataModel.producto ; //jsonData[dataModel.indexOrder]


    }

    Rectangle {
      id: loginForm
      anchors.centerIn: parent
      color: "white"
      width: content.width + dp(150)
      height: content.height + dp(48)
      radius: dp(4)
    }


   GridLayout {

       id: content
       anchors.centerIn: loginForm
       columnSpacing: dp(20)
       rowSpacing: dp(10)
       columns: 2

       // headline
       AppText {
         Layout.topMargin: dp(8)
         Layout.bottomMargin: dp(12)
         Layout.columnSpan: 2
         Layout.alignment: Qt.AlignHCenter
         text: "Producto a Solicitar"
       }

       AppText {
         text: qsTr("Nombre :")
         font.pixelSize: sp(14)
       }

       AppText {
         text: qsTr(myData.cDescripcion)
         font.pixelSize: sp(14)
       }

       AppText {
         text: qsTr("Sku :")
         font.pixelSize: sp(14)
       }

       AppText {
         text: qsTr(myData.sku)
         font.pixelSize: sp(14)
       }

       AppText {
         text: qsTr("Existencia :")
         font.pixelSize: sp(14)
       }

       AppText {
         text: qsTr(myData.nQuantity.toString())
         font.pixelSize: sp(14)
       }



       Column {
         Layout.fillWidth: true
         Layout.columnSpan: 2
         Layout.topMargin: dp(12)


         AppText {
           text: qsTr("Solicita :")
           font.pixelSize: sp(14)
         }

         SpinBox {

             //down.implicitIndicatorWidth: 30
             //up.implicitIndicatorWidth: 30

             id : mySpinBox

             width: parent.width
             height: 100

             from : 1
             to : 1000
             value: 1
         }


         // buttons
         AppButton {
           text: qsTr("Confirmar")
           flat: false
           anchors.horizontalCenter: parent.horizontalCenter
           onClicked: {
                //loginPage.forceActiveFocus() // move focus away from text fields

                myData.solicita = mySpinBox.value
                myData.idvendedorps = 1 ; // En realidad este es el estatus del pedido
                myData.idpuntosdeventa = dataModel.body.idseller
                myData.dTimeStamp = dataModel.getFormatDate()


                console.log( JSON.stringify(myData) )

                buildOrder(myData)





           }
         }

         AppButton {
           text: qsTr("Cancelar")
           flat: true
           anchors.horizontalCenter: parent.horizontalCenter
           onClicked: {
             //loginPage.forceActiveFocus() // move focus away from text fields

           }
         }
       }




   }

   function buildOrder( order )
   {
                  //"https://mxgsesoftware.com/pos/login/
       //.post("https://mxgsesoftware.com/home/zcxqxhso/pos/orders")

       //            https://mxgsesoftware.com/home/zcxqxhso/app/orders

       HttpRequest
              .post("https://mxgsesoftware.com/pos/orders")
              .set('Content-Type', 'application/json')
              .send(order)
              .timeout(8000)
              .then(function(res) {
                console.log(res.status);
                console.log(JSON.stringify(res.header, null, 4));
                console.log(JSON.stringify(res.body, null, 4));

                console.log( "La orden ha sido enviada")


                nativeUtils.displayMessageBox("La orden ha sido enviada", "", 1)

                navigationStack.pop()



              })
              .catch(function(err) {
                console.log(err.message)
                console.log(err.response)

                nativeUtils.displayMessageBox("Error al procesar", err.message, 1)



              });


   }


}
