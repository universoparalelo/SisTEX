const API_URL = 'http://localhost:8000'

const xhr = new XMLHttpRequest();

function onRequestHandler(){
    if (this.readyState === 4 && this.status === 200){
        
        const data = JSON.parse(this.response)
        const divAM = document.getElementById("datosAnalisisMicrobiologico")

        // console.log(data)
        // console.log(data.length)

        let detalleAnalisisMicro = ''

        for(let i = 0; i < data.length; i++){
            detalleAnalisisMicro += `
            <input type="checkbox" class="checkSeccion3 opciones" name="aM" onclick="precioTotal(${data[i].precio})">
            <label for="aerobiasMesofilas">${data[i].tipo_muestra} $${data[i].precio}</label><br>
            `
        }

        divAM.innerHTML = `
        <label>Opciones:</label><br>` + detalleAnalisisMicro
    }
}

xhr.addEventListener("load", onRequestHandler);
xhr.open('GET', `${API_URL}/api/tipomuestras`);
xhr.send();


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
    } else {
        document.getElementById("datosAnalisisFisicoquimico").setAttribute('hidden', true)
    }

    try{
        if (document.querySelector(".analisisFisicoquimico0").checked){
            document.querySelector(".datosAnalisisFisicoquimico0").removeAttribute('hidden')
        } else {
            document.querySelector(".datosAnalisisFisicoquimico0").setAttribute('hidden', true)
        }
    
        if (document.querySelector(".analisisFisicoquimico1").checked){
            document.querySelector(".datosAnalisisFisicoquimico1").removeAttribute('hidden')
        } else {
            document.querySelector(".datosAnalisisFisicoquimico1").setAttribute('hidden', true)
        }
    
        if (document.querySelector(".analisisFisicoquimico2").checked){
            document.querySelector(".datosAnalisisFisicoquimico2").removeAttribute('hidden')
        } else {
            document.querySelector(".datosAnalisisFisicoquimico2").setAttribute('hidden', true)
        }
    
        if (document.querySelector(".analisisFisicoquimico3").checked){
            document.querySelector(".datosAnalisisFisicoquimico3").removeAttribute('hidden')
        } else {
            document.querySelector(".datosAnalisisFisicoquimico3").setAttribute('hidden', true)
        }
    } catch(error){
        console.log('Error'+error.message)
    }
}

function mostrarMicro(){
    if (document.getElementById("analisisMicrobiologico").checked){
        document.getElementById("datosAnalisisMicrobiologico").removeAttribute('hidden')
        return;
    } else {
        document.getElementById("datosAnalisisMicrobiologico").setAttribute('hidden', true)
    }

    try{
        if (document.querySelector(".analisisMicrobiologico0").checked){
            document.querySelector(".datosAnalisisMicrobiologico0").removeAttribute('hidden')
            return;
        } else {
            document.querySelector(".datosAnalisisMicrobiologico0").setAttribute('hidden', true)
        }
    
        if (document.querySelector(".analisisMicrobiologico1").checked){
            document.querySelector(".datosAnalisisMicrobiologico1").removeAttribute('hidden')
            return;
        } else {
            document.querySelector(".datosAnalisisMicrobiologico1").setAttribute('hidden', true)
        }
    
        if (document.querySelector(".analisisMicrobiologico2").checked){
            document.querySelector(".datosAnalisisMicrobiologico2").removeAttribute('hidden')
            return;
        } else {
            document.querySelector(".datosAnalisisMicrobiologico2").setAttribute('hidden', true)
        }
    
        if (document.querySelector(".analisisMicrobiologico3").checked){
            document.querySelector(".datosAnalisisMicrobiologico3").removeAttribute('hidden')
            return;
        } else {
            document.querySelector(".datosAnalisisMicrobiologico3").setAttribute('hidden', true)
        }
    } catch(error){
        console.log('Error:', error.message)
    }
}

var total = 0

function precioTotal(value){
    let elementosCheck = document.querySelectorAll('.checkSeccion3')
    const elementoPrecioTotal = document.getElementById("inputPrecioTotal")

    total += parseInt(value)
    elementoPrecioTotal.value = 'Precio Total: $' + total

    console.log(total)
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

      if (step == 1){
        repetirSeccion();
      } else if (step == 2){
        repetirSeccion3();
      }
      
    }
}
  
function prevStep(step) {
    // Chequear que si vuelve de la seccion 2 a la 1 no haya errores en la cantidad de divs clonados
    if (step == 0){
        let elementoPadre = document.getElementById('secciones-clonadas')

        while (elementoPadre.firstChild) {
            elementoPadre.removeChild(elementoPadre.firstChild);
            }
    } else if (step == 1){
        let elementoPadre = document.getElementById('elementosClonados3')

        while (elementoPadre.firstChild) {
            elementoPadre.removeChild(elementoPadre.firstChild);
            }
    }

    // Ocultar paso actual y mostrar paso anterior
    document.getElementsByClassName('step')[currentStep].classList.remove('active');
    document.getElementsByClassName('step')[step].classList.add('active');

    currentStep = step;
}

function validateFields(step){
    switch (step) {
        case 0:
            if (document.getElementById("nombre").value===''|
                document.getElementById("apellido").value===''|
                document.getElementById("provincia").value ===''|
                document.getElementById("localidad").value===''|
                document.getElementById("dni").value===''){
                    return false
                } else return true
        case 1:
            if (document.getElementById("denominacionMuestra").value === ''|
                document.getElementById("marca").value === ''|
                document.getElementById("razonSocial").value === ''|
                document.getElementById("direccion").value === ''|
                (document.getElementById("checkboxLote").checked === false && document.getElementById("lote").value === '')|
                document.getElementById("lote").value === ''|
                document.getElementById("fechaElaboracion").value ===''|
                document.getElementById("fechaVencimiento").value ===''|
                document.getElementById("fechaElaboracion").value > document.getElementById("fechaVencimiento").value){
                    return false;
                } else {
                    xhr.addEventListener("load", onRequestHandler);
                    xhr.open('GET', `${API_URL}/api/tipomuestras`);
                    xhr.send();
                    return true;
                }
                
        case 2:
            return true;
        case 3:
            if (document.getElementById("comprobante").value === ''){
                return false;
            } else return true;
    }
}

function repetirSeccion(){
    // Obtenemos la cantidad de productos seleccionada por el usuario
    const cantidadProductos = document.getElementById('cantidadProducto').value;

    const seccionOriginal = document.getElementById("elementosSeccion2");
    const contenedorClonadas = document.getElementById("secciones-clonadas");

    for (let i = 0; i < cantidadProductos-1; i++) {
        const clon = seccionOriginal.cloneNode(true);
        contenedorClonadas.appendChild(clon);
    }
}

function repetirSeccion3(){
    const cantidadProductos = document.getElementById('cantidadProducto').value;

    const seccionOriginal = document.getElementById("elementosSeccion3");
    const contenedorClonadas = document.getElementById("elementosClonados3");

    for (let i = 0; i < cantidadProductos-1; i++) {
        const clon = seccionOriginal.cloneNode(true);
        contenedorClonadas.appendChild(clon);

        let elementoFisicoquimico = clon.querySelector("#analisisFisicoquimico");
        let elementoDatosFisicoquimico = clon.querySelector("#datosAnalisisFisicoquimico");

        let elementoMicrobiologico = clon.querySelector("#analisisMicrobiologico");
        let elementoDatosMicrobiologico = clon.querySelector("#datosAnalisisMicrobiologico");

        elementoFisicoquimico.classList.add(`analisisFisicoquimico${i}`);
        elementoDatosFisicoquimico.classList.add(`datosAnalisisFisicoquimico${i}`);

        elementoMicrobiologico.classList.add(`analisisMicrobiologico${i}`);
        elementoDatosMicrobiologico.classList.add(`datosAnalisisMicrobiologico${i}`);
    }
}




  
  