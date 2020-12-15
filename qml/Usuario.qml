import QtQuick 2.0
import Felgo 3.0

FlickablePage {

    id: item

    title : "Digital Shop Usuario"

    Column {

        anchors.centerIn: parent

        spacing : 100



        AppButton{

            id : redirButton


            text: "Punto Venta - Sub Dis"

            anchors.horizontalCenter: parent.horizontalCenter

            radius : 20


            onClicked: {

                redirect()

            }

        }

        AppButton{

            id : addButton

            anchors.horizontalCenter: parent.horizontalCenter

            text: "Agrega Puntos de Venta - Sub Dis"

            //height: 100
            //width: 150

            radius : 20


            onClicked: {

                if ( dataModel.body.sellerType === 2 )
                {
                    nativeUtils.displayMessageBox("Usted es punto de venta no se puede usar esta opción", "ok", 1)
                    return ;

                }

                item.navigationStack.push(myPuntoDeVenta)

            }

        }


    }


    function redirect()
    {

        if ( dataModel.body === null )
        {
            nativeUtils.displayMessageBox("No seha registrado ...", "", 1)

            return ;
        }

        if ( dataModel.body.sellerType === 2 )
        {
            console.log( "Ahora si, punto de venta")
            var properties = { title: "Punto de Venta "  }
            item.navigationStack.push(myPuntoVenta,properties)
        }


        if ( dataModel.body.sellerType === 3 )
        {
            console.log( "Ahora si, distribuidor")
             properties = { title: "Distribuidor "  }
            item.navigationStack.push(myDistribuidor,properties)
        }


        if ( dataModel.body.sellerType === 1 )
        {
            console.log( "Ahora si, Sub Distribuidor")
             properties = { title: "Sub Distribuidor "  }
            item.navigationStack.push(myDistribuidor,properties)
        }
    }

    Component {

        id : myPuntoDeVenta

        AddPuntoVenta{}
    }






}
