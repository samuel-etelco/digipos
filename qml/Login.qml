import Felgo 3.0
 import QtQuick 2.0
 import QtQuick.Layouts 1.1

 Page {
   id: loginPage
   title: qsTr("Digital Shop Login...")

   backgroundColor: Qt.rgba(0,0,0, 0.75) // page background is translucent, we can see other items beneath the page
   useSafeArea: false // do not consider safe area insets of screen

   Component.onCompleted: {


       if ( isLoged == false )
       {

           console.log( "isLoged") ;

           loginPage.opacity = 1.0
       }
       else
       {
           loginPage.opacity = 0.0
       }
   }

   Image {
       id: logo
       source: "../assets/LogoDigital.png"
       anchors.centerIn: parent
       fillMode: Image.PreserveAspectFit
       visible: false
   }


   // login form background
   Rectangle {
     id: loginForm
     anchors.centerIn: parent
     color: "white"
     width: content.width + dp(48)
     height: content.height + dp(16)
     radius: dp(4)
   }

   // login form content
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
       text: "Login"
     }

     // email text and field
     AppText {
       text: qsTr("Usuario")
       font.pixelSize: sp(12)
     }

     AppTextField {
       id: txtUsername
       Layout.preferredWidth: dp(200)
       showClearButton: true
       font.pixelSize: sp(14)
       borderColor: Theme.tintColor
       borderWidth: !Theme.isAndroid ? dp(2) : 0
     }

     // password text and field
     AppText {
       text: qsTr("Contraseña")
       font.pixelSize: sp(12)
     }

     AppTextField {
       id: txtPassword
       Layout.preferredWidth: dp(200)
       showClearButton: true
       font.pixelSize: sp(14)
       borderColor: Theme.tintColor
       borderWidth: !Theme.isAndroid ? dp(2) : 0
       echoMode: TextInput.Password
     }

     // column for buttons, we use column here to avoid additional spacing between buttons
     Column {
       Layout.fillWidth: true
       Layout.columnSpan: 2
       Layout.topMargin: dp(12)

       // buttons
       AppButton {
         text: qsTr("Login")
         flat: false
         anchors.horizontalCenter: parent.horizontalCenter
         onClicked: {
           loginPage.forceActiveFocus() // move focus away from text fields
            //isLoged = true ;

             //loginPage.enabled = false ;
             //loginPage.opacity = 0.0 ;

             //console.log( "isLoged = true")

           // call login action
            console.log( "Tecnico logeado = " + txtUsername.text ) ;
            console.log( "Password = " + txtPassword.text ) ;
           //logic.login(txtUsername.text, txtPassword.text)


             loadJsonData() ;

             //logic.setUserSelected( "4" ,txtUsername.text , txtPassword.text )


         }
       }

       AppButton {
         text: qsTr("No tiene cuenta? Reportarlo a su Gerente")
         flat: true
         anchors.horizontalCenter: parent.horizontalCenter
         onClicked: {
           loginPage.forceActiveFocus() // move focus away from text fields

           // call your logic action to register here
           console.debug("registering...")
         }
       }
     }
   }


   function loadJsonData() {


       if ( txtUsername.text.trim() === "" || txtPassword.text.trim() === "" )
       {
           return ;
       }

       var theUrl = "https://mxgsesoftware.com/pos/login/" + txtUsername.text + "/" + txtPassword.text ;


       HttpRequest
              .get(theUrl)
              .timeout(9000)
              .then(function(res) {
                console.log(res.status);
                console.log(JSON.stringify(res.header, null, 4));

                console.log( typeof res.body )

                if ( typeof res.body === "string")
                {

                    if ( res.body.indexOf( "notAvailable" ) >= 0 )
                    {
                        nativeUtils.displayMessageBox("Usuario no existente", "", 1)
                        return ;
                    }
                }


                console.log(JSON.stringify(res.body, null, 4));


                if (res.body[0].nIsActive === 0  )
                {
                    nativeUtils.displayMessageBox("Usuario no esta activo", "", 1)

                    txtUsername.text = ""
                    txtPassword.text = ""
                    return ;
                }




                var name = "Bienvenido " + res.body[0].cName

                nativeUtils.displayMessageBox(name, "", 2)



                loginForm.visible = false
                content.visible = false
                logo.visible = true


                //loginPage.opacity = 0.0 ;


                isLoged = true ;



                console.log( "isLoged = true")

                if ( res.body[0].isPos === 1 )
                {
                    console.log( "Es un Punto de Venta") ;
                }
                else
                {
                    console.log( "Es un distribidor")
                }

                logic.setBody( res.body[0] )




              })
              .catch(function(err) {
                console.log(err.message)
                console.log(err.response)

                nativeUtils.displayMessageBox("Usuario no existente", "", 1)

              });

   }

 }
