function mostrarBloque_estilos(){
    let option = document.getElementById("producto").value
    // console.log(option)
    if (option == 'Cerveza'){
        document.getElementById("bloque_estilos").removeAttribute('hidden')
    } else {
        document.getElementById("bloque_estilos").setAttribute('hidden', true)
    }
}

function ocultarLote(){
    if (document.getElementById("checkboxLote").checked){
        document.getElementById("lote").setAttribute('disabled', true)
        document.getElementById("lote").value = ''
    } else {
        document.getElementById("lote").removeAttribute('disabled')
    }
}

function mostrarFisico(){
    if (document.getElementById("analisisFisicoquimico").checked){
        document.getElementById("datosAnalisisFisicoquimico").removeAttribute('hidden')
        // document.getElementById("lote").value = ''
    } else {
        document.getElementById("datosAnalisisFisicoquimico").setAttribute('hidden', true)
        document.getElementById("pdfAnalisisFisicoquimico").value = ''
        document.getElementById("analisisTexto").value = ''
    }
}

function mostrarMicro(){
    if (document.getElementById("analisisMicrobiologico").checked){
        document.getElementById("datosAnalisisMicrobiologico").removeAttribute('hidden')
        // document.getElementById("lote").value = ''
    } else {
        document.getElementById("datosAnalisisMicrobiologico").setAttribute('hidden', true)
    }
}

function precioTotal(nombreElemento, value){
    let elemento = document.getElementById(nombreElemento)
    let campoPrecio = document.getElementById("precioTotalCampo")
    if (elemento.checked){
        campoPrecio.value = parseInt(campoPrecio.value) + parseInt(value)
    } else {
        campoPrecio.value = parseInt(campoPrecio.value) - parseInt(value)
    }
}


// console.log(document.getElementById("hongosLevaduras").value)

function MostrarOtro(){
    if (document.getElementById("radioOtro").checked){
        document.getElementById("otroRazon").removeAttribute("disabled")
    } else {
        document.getElementById("otroRazon").setAttribute("disabled", true)
        document.getElementById("otroRazon").value = ''
    }
}

// Variables para controlar el stepper
var currentStep = 0;
var totalSteps = 5;

function nextStep(step) {
    // Validar campos antes de avanzar al siguiente paso
    if (validateFields(step-1)) {
      // Ocultar paso actual y mostrar siguiente paso
      document.getElementsByClassName('step')[currentStep].classList.remove('active');
      document.getElementsByClassName('step')[step].classList.add('active');
  
      currentStep = step; 
    }
  }
  
  function prevStep(step) {
      // Ocultar paso actual y mostrar paso anterior
      document.getElementsByClassName('step')[currentStep].classList.remove('active');
      document.getElementsByClassName('step')[step].classList.add('active');
    
      currentStep = step;
  }

  function validateFields(step){
    switch (step) {
        case 0:
            if (document.getElementById("nombre")===''|
                document.getElementById("apellido")===''|
                document.getElementById("direccion")===''|
                document.getElementById("provincia").value ===''|
                document.getElementById("localidad")===''|
                document.getElementById("telefono")===''){
                    return false
                } else return true
            break;
        case 1:
            if (document.getElementById("nombreMuestra")===''|
                document.getElementById("producto").value === 'Cervezas' && document.getElementById("estilos").value === ''|
                document.getElementById("producto").value === ''|
                document.getElementById("checkboxLote").checked === false && document.getElementById("lote").value === ''|
                document.getElementById("lote") === ''|
                document.getElementById("fechaElaboracion").value===''|
                document.getElementById("fechaVencimiento").value===''|
                document.getElementById("fechaElaboracion").value > document.getElementById("fechaVencimiento").value){
                    return false
                } else return true
            break;
        case 2:
            if (document.getElementById("analisisFisicoquimico").checked === false &
                document.getElementById("aerobiasMesofilas").checked === false &
                document.getElementById("coliformesEcoli").checked === false &
                document.getElementById("salmonella").checked === false &
                document.getElementById("pseudomonaAeruginosa").checked === false &
                document.getElementById("bacteriasLacticas").checked === false &
                document.getElementById("enterobacterias").checked === false &
                document.getElementById("staphylococcusAureus").checked === false &
                document.getElementById("hongosLevaduras").checked === false &
                document.getElementById("determinacionNutricional").checked === false &
                document.getElementById("azucaresTotales").checked === false){
                return false
            } else return true
            break;
        case 3:
            let checkboxes = document.querySelectorAll('input[name="razon"]');
            let checkboxes2 = document.querySelectorAll('input[name="temperatura"]');
            let isChecked = true 
            let isChecked2 = true; 

            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    isChecked = false;
                    break; 
                }
            }
            for (var i = 0; i < checkboxes2.length; i++) {
                if (checkboxes2[i].checked) {
                    isChecked2 = false; 
                    break; 
                }
            }
            // si isChecked == true entonces no chequeo nada
            // si isChecked == false entonces chequeo uno
            if ( // isChecked == true si 
                document.getElementById("codigoAlimentario").value === '' |
                document.getElementById("lapsoAptitud").value === '' |
                isChecked | isChecked2 |
                document.getElementById("radioOtro").checked && document.getElementById("otroRazon").value == ''
            ){
                return false;
            } else return true;
            break;
        case 4:
            if (document.getElementById("comprobante").value === ''){
                return false;
            } else return true;
            break;
    }
  }
  