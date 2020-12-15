import Felgo 3.0
import QtQuick 2.6

import QtQuick.Controls 2.4
import QtQuick.Layouts 1.12

FlickablePage {
  id: root


  property bool allFieldsValid: nameField.isInputCorrect && emailField.isInputCorrect &&
        passwordField.isInputCorrect && confirmPasswordField.isInputCorrect &&
        termsOfServiceCheck.checked

  title: qsTr("Digital Shop Nuevo punto de Venta")
  flickable.contentHeight: content.height

  rightBarItem: NavigationBarRow {
    ActivityIndicatorBarItem {
      visible: true
      animating: HttpNetworkActivityIndicator.enabled
      showItem: showItemAlways
    }

  }

  Component.onCompleted: {

      if ( dataModel.body.sellerType === 1 ) // En caso de un subdistribuidor , no se selecciona nada
      {
          console.log( "visible = false ")
          myRowLayout.visible = false ; // Le quitamos la visibilidad
          pVentaButton.checked = true ; // Lo dejamos como punto de venta
      }
      else
      {
          console.log( "visible = true") ;


      }

  }



  Column {
    id: content
    spacing: constants.defaultMargins
    topPadding: constants.defaultMargins
    bottomPadding: constants.defaultMargins
    //leftPadding: 40

    anchors.leftMargin: sp(12)

    anchors.rightMargin: sp(12)


    anchors { left: parent.left; right: parent.right; margins: constants.defaultMargins }

    // we are not enforcing anything on its height. It will grow as necessary, and the page FlickablePage
    // will kick in making the content scrollable.


   ComboBox {

       currentIndex: 0

       width: 400
       height: 75



       anchors.horizontalCenter: root.anchors.horizontalCenter

       id : myRowLayout

       model : ["Seleccione tipo" , "SubDistribuidor" , "Punto de Venta"]
   }


    ValidatedField {
      id: nameField
      label: qsTr("Nombre")
      placeholderText: qsTr("Nombre ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /[\w ]+/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Nombre no Valido")
    }

    ValidatedField {
      id: emailField
      label: qsTr("Email")
      placeholderText: qsTr("Correo ...")

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("El correo no es valido")

      // customize the text field to automatically discard invalid input and displays a "clear" text icon
      textField.inputMode: textField.inputModeEmail
    }

    ValidatedField {
      id: usuarioField
      label: qsTr("Usuario")
      placeholderText: qsTr("Usuario ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /[\w ]+/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Usuario no Valido")
    }




    ValidatedField {
      id: passwordField

      // we display an error message if the password length is less than 6
      property bool isPasswordTooShort: textField.text.length > 0 && textField.text.length < 6

      // this hides characters by default
      textField.inputMode: textField.inputModePassword
      label: qsTr("Password")
      placeholderText: qsTr("Password ...")

      hasError: isPasswordTooShort
      errorMessage: qsTr("Password muy corto")
    }

    ValidatedField {
      id: confirmPasswordField

      property bool arePasswordsDifferent: passwordField.textField.text != confirmPasswordField.textField.text

      label: qsTr("Confirma Password")
      placeholderText: qsTr("Confirme el Password ...")
      textField.inputMode: textField.inputModePassword

      // we display an error message when the two password are different
      hasError: arePasswordsDifferent
      errorMessage: qsTr("Passwords no empatan")
    }

    ValidatedField {
      id: calleField
      label: qsTr("Calle")
      placeholderText: qsTr("Calle ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /[\w ]+/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Calle no Valida")
    }


    ValidatedField {
      id: nExtField ; // Numero exterior
      label: qsTr("Num Exterior")
      placeholderText: qsTr("Num Exterior ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /^([0-9])+$/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Num Exterior no valido")
    }


    ValidatedField {
      id: nIntField ; // Numero exterior
      label: qsTr("Num Interior")
      placeholderText: qsTr("Num Interior ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /^([0-9])*$/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Num Interior no valido")
    }

    ValidatedField {
      id: cCPField ; // CP
      label: qsTr("CP")
      placeholderText: qsTr("CP ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /^([0-9]){5}$/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("CP no Valido")
    }


    AppButton {
      anchors.horizontalCenter: parent.horizontalCenter
      //enabled: root.allFieldsValid
      text: qsTr("Buscar CP")

      id : cpButton
      onClicked: {

        cpButton.forceActiveFocus()
        console.log( "A buscar CP" ) ;

          if ( cCPField.textField.text.length != 5 )
          {
              return ;
          }


          sendCp(cCPField.textField.text)
      }
    }



    ValidatedField {
      id: cColoniaField ; // Numero exterior
      label: qsTr("Colonia")
      placeholderText: qsTr("Colonia ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /[\w ]+/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Colonia no Valida")
    }


    ValidatedField {
      id: cAlcaldiaField ; // Numero exterior
      label: qsTr("Alcaldia")
      placeholderText: qsTr("Alcaldia ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /[\w ]+/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Alcaldia no Valida")
    }



    ValidatedField {
      id: cCiudadField ; // Numero exterior
      label: qsTr("Ciudad")
      placeholderText: qsTr("Ciudad ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /[\w ]+/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Ciudad no Valida")
    }

    ValidatedField {
      id: cTel1 ; // Numero exterior
      label: qsTr("Telefono1")
      placeholderText: qsTr("Telefono1 ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /[0-9]{0}|[0-9]{10}/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Telefono1 no Valido")
    }


    ValidatedField {
      id: cTel2 ; // Numero exterior
      label: qsTr("Telefono2")
      placeholderText: qsTr("Telefono2 ...")

      // we only allow names composed by letters and spaces
      validator: RegExpValidator {
        regExp: /[0-9]{0}|[0-9]{10}/
      }

      // when the active focus is taken away from the textField we check if we need to display an error
      textField.onActiveFocusChanged: {
        hasError = !textField.activeFocus && !textField.acceptableInput
      }

      errorMessage: qsTr("Telefono2 no Valido")
    }


    RowLayout {


        AppCheckBox {
          id: activo
          width: parent.width
          text: qsTr("Activo ?")

          onClicked: {

              activo.forceActiveFocus()
          }


        }






        AppCheckBox {
          id: termsOfServiceCheck
          width: parent.width
          labelFontSize: sp(11)
          text: qsTr("De acuerdo con los datos capturados ???")

          onClicked: {
              termsOfServiceCheck.forceActiveFocus()
          }


        }

    }


    // the submit button is only enabled if every field is valid and without error.
    AppButton {
      anchors.horizontalCenter: parent.horizontalCenter
      enabled: root.allFieldsValid
      text: qsTr("Guardar")

      id : altaButton

      onClicked: {

        console.log( activo.checked ) ;

        processAlta() ;

      }
    }
  }

  function processAlta()
  {
      var obj = {} ;

      obj.cName = nameField.textField.text
      obj.eMail = emailField.textField.text
      obj.cUser = usuarioField.textField.text
      obj.cPassword = passwordField.textField.text
      obj.cCalle = calleField.textField.text
      obj.cNumExt = nExtField.textField.text
      obj.cNumInt = nIntField.textField.text

      obj.cColonia = cColoniaField.textField.text
      obj.cAlcaldia = cAlcaldiaField.textField.text
      obj.cCP = cCPField.textField.text
      obj.cCiudad = cCiudadField.textField.text
      obj.cTel1 = cTel1.textField.text
      obj.cTel2 = cTel2.textField.text
      obj.nIsActive = activo.checked === true ? 1 : 0 ;
      obj.dTimeStamp = dataModel.getFormatDate() ;

      // 1 = Sub Distribuidor 2 = Punto de Venta

      var type = 2 ;

      if ( myRowLayout.visible === true )
      {
          if ( myRowLayout.currentIndex === 0 )
          {
              nativeUtils.displayMessageBox("Favor de seleccionar tipo valido","" , 1)
              return ;
          }
          type = myRowLayout.currentIndex ;
      }


      obj.sellerType = type ; // distButton.checked === true ? 1 : 2  ;
      obj.idDistribuidor = dataModel.body.idseller ;

      // idSeller

      console.log( JSON.stringify(obj))

      sendPv(obj)


  }

  function sendCp( cp )
  {

      var cadena = "https://mxgsesoftware.com/pos/getcp/" + cp ;

      //console.log( cadena )

      //nativeUtils.displayMessageBox( "Antes", cadena , 1)



      HttpRequest
             .get(cadena  )
             .set('Content-Type', 'application/json')
             .timeout(8000)
             .then(function(res) {
               console.log(res.status);
               console.log(JSON.stringify(res.header, null, 4));
               console.log(JSON.stringify(res.body, null, 4));


                 if ( res.body.length === 0 )
                 {
                     nativeUtils.displayMessageBox("No se encontro este codigo postal","" , 1)

                     return ;
                 }


                cCiudadField.textField.text = res.body[0].POB ;
                cColoniaField.textField.text = res.body[0].COL ;
                cAlcaldiaField.textField.text = res.body[0].MUNI ;


                //nativeUtils.displayMessageBox("Respuesta ",res.body[0].POB , 1)


             })
             .catch(function(err) {
               console.log(err.message)
               console.log(err.response)
                 nativeUtils.displayMessageBox("Error al solicitar CP"  , err.message , 1)

             });


  }

  function sendPv( obj)
  {

      altaButton.enabled = false


      HttpRequest
             .post("https://mxgsesoftware.com/pos/setuppv")
             .set('Content-Type', 'application/json')
             .send( obj )
             .timeout(8000)
             .then(function(res) {
               console.log(res.status);
               console.log(JSON.stringify(res.header, null, 4));
               //console.log(JSON.stringify(res.body, null, 4));



                 nativeUtils.displayMessageBox("Se ha creado el nuevo registro", "ok", 1)



                 var lect = {}

                 lect.califica = 1 ;
                 lect.observaciones = "Alta PV"
                 logic.setObservaCalifica( lect )



                 root.navigationStack.push(thisCamera)



             })
             .catch(function(err) {
               console.log(err.message)
               console.log(err.response)
                 nativeUtils.displayMessageBox("Error al enviar el registro"  , err.message , 1)

                 altaButton.enabled = true

             });


  }

  Component {

      id :thisCamera

      CameraDigital{}

  }
}
