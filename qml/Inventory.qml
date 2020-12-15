import QtQuick 2.0
import Felgo 3.0

Page {

    id: inventoryPage

    title: qsTr("Digital Shop ...Inventario")


    property var jsonData: []



    rightBarItem: NavigationBarRow {
      ActivityIndicatorBarItem {
        visible: true
        animating: HttpNetworkActivityIndicator.enabled
        showItem: showItemAlways
      }

    }

    Component.onCompleted: {
        HttpNetworkActivityIndicator.activationDelay = 0
        HttpNetworkActivityIndicator.completionDelay = 2000

      loadJsonData()

      myInventory = inventoryPage
    }

    onVisibleChanged: {

        console.log( "onVisibleChanged")

        if ( visible === true )
        {
            if ( isLoged === true && jsonData === [] )
            {
                loadJsonData() ; // Intenta cargar inventario
            }
        }

    }


    JsonListModel {
      id: jsonModel
      source: inventoryPage.jsonData
      keyField: "id"
    }


    ListPage {
      title: "Seleccione una Orden"


      SearchBar {
        id: searchBar
        target: myListView
        pullEnabled: true
        showClearButton: true
        placeHolderText: "Buscar"
        //showDivider:true
        onAccepted: {
          console.log("search accepted: "+text)
/*
          var theArray = getMatchArray( jsonData , text )
          //listView.model = 2 // update result

          if ( theArray.legnth === 0 )
          {
              text = "" ;

              return ;
          }

          var theNewArray = [] ;

          for( var i = 0 ; i < theArray.length ; i++ )
          {
              theNewArray.push( jsonData[theArray[i]] ) ;
          }

          logic.setDataFilter( theNewArray ) ;

            //console.log( "onAccepted" + jsonData[0].cDescripcion) ;

          page.navigationStack.push(myFiltrado) ;
*/
        }
      }


      AppListView {

          id : myListView


          //spacing: 10
        model: jsonModel

        delegate: SimpleRow {

            text : model.cDescripcion

            detailText: buildDetail()
            //icon: IconType.mobilephone

            onSelected: {
                //pageLoader.source = "AProcesarData.qml"

                console.log(index)

/*

                console.log(JSON.stringify(model.Interlocutor))

*/

            }


            function buildDetail()
            {
                var text = "Sku       : " +model.sku +"\n" ;
                    text +="Cantidad : " +model.nQuantity + "\n" ;
                    text +="Precio    : " + model.nPrice + "\n" ;
                    text +="Color     : " +  model.cColor + "\n"  ;

                return text ;

            }


        }


      }
    }


    function loadJsonData()
    {

        console.log( "Llamando a loadJsonData()")




        var theUrl = "https://mxgsesoftware.com/pos/getinventory/" + dataModel.body.idseller + "/1"  ;

        console.log( "theUrl = " + theUrl ) ;


        HttpRequest
               .get(theUrl)
               .timeout(6000)
               .then(function(res) {
                 console.log(res.status);
                 console.log(JSON.stringify(res.header, null, 4));
                 console.log(JSON.stringify(res.body, null, 4));


                //nativeUtils.displayMessageBox("Llego la respuesta", "", 1)

                inventoryPage.jsonData = res.body




               })
               .catch(function(err) {
                 console.log(err.message)
                 console.log(err.response)

                 nativeUtils.displayMessageBox("Error al solicitar el inventario", "", 1)

               });


    }



}
