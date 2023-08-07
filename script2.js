


const API_URL = 'http://localhost:8000';
const xhr = new XMLHttpRequest();
var contador = 0;

function onRequestHandler(){
    if (this.readyState === 4 && this.status === 200){
        
        data = JSON.parse(this.response);
    };
};

xhr.addEventListener("load", onRequestHandler);
xhr.open('GET', `${API_URL}/api/tipomuestras`);
xhr.send();

var total = 0;

function precioTotal(value, idClase){
    let elementoCheck = document.querySelector(`.${idClase}`);
    
    const elementoPrecioTotal = document.getElementById("inputPrecioTotal");

    if (elementoCheck.checked){
        total += parseInt(value);
    } else {
        total -= parseInt(value);
    };

    elementoPrecioTotal.value = 'Precio Total: $' + total;
    console.log(total);
};


function ocultarLote(){
    if (document.getElementById("checkboxLote").checked){
        document.getElementById("lote").setAttribute('disabled', true);
        document.getElementById("lote").value = '';
    } else {
        document.getElementById("lote").removeAttribute('disabled');
    };
};

function mostrar(idInput, idHidden){
    if (document.querySelector(`.${idInput}`).checked){
        document.querySelector(`.${idHidden}`).removeAttribute('hidden');
    } else {
        document.querySelector(`.${idHidden}`).setAttribute('hidden', true);
    };
}


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
    } 
    // else if (step == 1){
    //     let elementoPadre = document.querySelector('.elementosSeccion3')

    //     while (elementoPadre.firstChild) {
    //         elementoPadre.removeChild(elementoPadre.firstChild);
    //         }
    // }

    // Ocultar paso actual y mostrar paso anterior
    document.getElementsByClassName('step')[currentStep].classList.remove('active');
    document.getElementsByClassName('step')[step].classList.add('active');

    currentStep = step;
}

function validateFields(step){
    switch (step) {
        case 0:
            // if (document.getElementById("nombre").value===''|
            //     document.getElementById("apellido").value===''|
            //     document.getElementById("provincia").value ===''|
            //     document.getElementById("localidad").value===''|
            //     document.getElementById("dni").value===''){
            //         return false
            //     } else return true
            return true
        case 1:
            // if (document.getElementById("denominacionMuestra").value === ''|
            //     document.getElementById("marca").value === ''|
            //     document.getElementById("razonSocial").value === ''|
            //     document.getElementById("direccion").value === ''|
            //     (document.getElementById("checkboxLote").checked === false && document.getElementById("lote").value === '')|
            //     document.getElementById("lote").value === ''|
            //     document.getElementById("fechaElaboracion").value ===''|
            //     document.getElementById("fechaVencimiento").value ===''|
            //     document.getElementById("fechaElaboracion").value > document.getElementById("fechaVencimiento").value){
            //         return false;
            //     } else {
            //         xhr.addEventListener("load", onRequestHandler);
            //         xhr.open('GET', `${API_URL}/api/tipomuestras`);
            //         xhr.send();
            //         return true;
            //     }
            return true
        case 2:
            return true;
        case 3:
            // if (document.getElementById("comprobante").value === ''){
            //     return false;
            // } else return true;
            return true
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

    // const seccionOriginal = document.getElementById("elementosSeccion3");
    const contenedor = document.getElementById("elementosSeccion3");
    let textoCompleto = '';

    for (let j = 0; j < cantidadProductos; j++) {

        textoCompleto += `<hr style="margin:10px 0;">
        <label for="analisisMicrobiologico">Análisis Microbiológico:</label>
        <input type="checkbox" class="analisisMicrobiologico-${j}" onclick="mostrar('analisisMicrobiologico-${j}', 'datosAnalisisMicrobiologico-${j}')"><br>
        
        <div class="datosAnalisisMicrobiologico-${j}" hidden>
        `

        let i = 0;

        while (data[i].tipo_muestra !== 'Completo') {
            textoCompleto += `
            <input type="checkbox" class="${data[i].id_tipo_muestra}-${contador}" name="aM" onclick="precioTotal(${data[i].precio}, '${data[i].id_tipo_muestra}')">
            <label for="aerobiasMesofilas">${data[i].tipo_muestra} $${data[i].precio}</label><br>
            `;
            i += 1;
        };
        contador += 1;
        
        textoCompleto += `
        </div>
        <label for="analisisFisicoquimico">${data[i].tipo_muestra} $${data[i].precio}:</label>
        <input type="checkbox" class="${data[i].id_tipo_muestra}-${j}" name="analisisFisicoquimico" onclick="mostrar('${data[i].id_tipo_muestra}-${j}', 'datosAnalisisFisicoquimico-${j}'); precioTotal(${data[i].precio}, '${data[i].id_tipo_muestra}-${j}')"><br>
        
        <div class="datosAnalisisFisicoquimico-${j}" hidden>
            <label for="pdfAnalisisFisicoquimico">Si es su primera vez analizando con nosotros:</label>
            <input type="file" id="analisisPDF">
        </div>
        
        <label for="determinacionNutricional">${data[i+1].tipo_muestra} $${data[i+1].precio}</label>
        <input type="checkbox" class="${data[i+1].id_tipo_muestra}-${j}" id="determinacionNutricional" onclick="precioTotal(${data[i+1].precio}, '${data[i+1].id_tipo_muestra}-${j}')"><br>
        
        <label for="azucaresTotales">${data[i+2].tipo_muestra} $${data[i+2].precio}</label>
        <input type="checkbox" class="${data[i+2].id_tipo_muestra}-${j}" id="azucaresTotales" onclick="precioTotal(${data[i+2].precio}, '${data[i+2].id_tipo_muestra}-${j}')"><br></br>`
        
    }

    contenedor.innerHTML = textoCompleto
}


function copiar(idInput){
    const myInput = document.getElementById(idInput);

    myInput.select();
    navigator.clipboard.writeText(myInput.value)
    .then(() => {
        Swal.fire({
            position: 'top',
            icon: 'success',
            title: 'Texto copiado en portapapeles',
            showConfirmButton: false,
            timer: 1500
          })
    })
    .catch(err => {
        // Manejar errores si la copia falla
        Swal.fire({
            position: 'top',
            icon: 'error',
            title: 'No se pudo copiar el texto',
            showConfirmButton: false,
            timer: 1500
          })
    });
}






  
  