import Felgo 3.0
import QtQuick 2.0

import "model"

App {
    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    id : mainApp


    property var  myInventory: null

    property bool isLoged : false

    property var usuario : null

    property  var  puntoventa: null



    DataModel {
      id: dataModel
      dispatcher: logic


    }

    Component.onCompleted: {

        //usuario = myUsuario
        puntoventa = myPuntoVenta
    }




    Logic {

        id : logic
    }



    Navigation {

        NavigationItem {

            title : qsTr("Digital Shops ...Home")

            icon: IconType.home


            NavigationStack {

                Page {
                    title: qsTr("Digital Shop")

                    Image {
                        source: "../assets/LogoDigital.png"
                        anchors.centerIn: parent

                        fillMode: Image.PreserveAspectFit

                        height: 200
                        width: 500
                    }
                }

                Login {}


            }

        }

        NavigationItem {
           title: "Login"
           icon: IconType.user

           NavigationStack {

              Login{}

           }
         }


        NavigationItem {

           id: myUsuario
           title: "Usuario"
           icon: IconType.eye



           NavigationStack {
               id : myUsuarioStack

               Usuario{}
               //Distribuidor{}

           }
         }



        NavigationItem {
           title: "Inventario"
           icon: IconType.book

           NavigationStack {

              Inventory{}

           }
         }


        NavigationItem {


           title: "Pedidos"
           icon: IconType.phone

           NavigationStack {

              Pedidos2{}

           }
         }




        NavigationItem {
           title: "Ventas"
           icon: IconType.dollar

           NavigationStack {

              Sales{}

           }
         }


        NavigationItem {
           title: "Evidencias"
           icon: IconType.camera

           NavigationStack {

              Evidencias{}

           }
         }


        NavigationItem {
          title: "Configuracion"
          icon: IconType.cogs

          NavigationStack {

              Config{}
            //Page { title: "Configuracion" ; }
          }
        }






    }

    Component{

        id : myPuntoVenta

        PuntoVenta{}
    }

    Component{

        id : myDistribuidor

        Distribuidor{}
    }

    Component{

        id : mySubdis

        SubDis{}
    }

    Component {
        id : myCamera

        CameraDigital{}
    }

}
