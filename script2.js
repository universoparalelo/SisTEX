


const API_URL = 'http://localhost:8000';
const xhr = new XMLHttpRequest();

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
    // console.log(total);
};


function ocultarLote(idInput, idCheck){
    if (document.querySelector(`.${idCheck}`).checked){
        document.querySelector(`.${idInput}`).setAttribute('disabled', true);
        document.querySelector(`.${idInput}`).value = '';
    } else {
        document.querySelector(`.${idInput}`).removeAttribute('disabled');
    };
};

function mostrar(idInput, idHidden){
    if (document.querySelector(`.${idInput}`).checked){
        document.querySelector(`.${idHidden}`).removeAttribute('hidden');
    } else {
        document.querySelector(`.${idHidden}`).setAttribute('hidden', true);
    };
}

function mostrarFisico(idInput, idHidden, idRadio){
    
    if (document.querySelector(`.${idInput}`).checked && document.querySelector(`.${idRadio}`).checked){
        document.querySelector(`.${idHidden}`).removeAttribute('hidden');
    } else {
        document.querySelector(`.${idHidden}`).setAttribute('hidden', true);
    };
}


function MostrarOtro(idInput, idInfo){
    if (document.querySelector(`.${idInput}`).checked){
        document.querySelector(`.${idInfo}`).removeAttribute("disabled");
    } else {
        document.querySelector(`.${idInfo}`).setAttribute("disabled", true);
        document.querySelector(`.${idInfo}`).value = '';
    };
};

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
        let elementoPadre = document.getElementById('elementosSeccion2')

        while (elementoPadre.firstChild) {
            elementoPadre.removeChild(elementoPadre.firstChild);
            }
    } 
    else if (step == 1){
        document.getElementById("inputPrecioTotal").value = 'Precio total: $0';
        total = 0;
    }

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
            return true;

            
        case 1:
            // let banderaSeccion2 = true;
            // cantidadProductos = document.getElementById('cantidadProducto').value;

            // for (let i=0; i<cantidadProductos.length; i++){
            //     if (document.querySelector(`.denominacionMuestra-${i}`).value === ''|
            //     document.querySelector(`.marca-${i}`).value === ''|
            //     document.querySelector(`.direccion-${i}`).value === ''|
            //     document.querySelector(`.fechaElaboracion-${i}`).value ===''|
            //     document.querySelector(`.fechaVencimiento-${i}`).value ===''|
            //     document.querySelector(`.fechaElaboracion-${i}`).value > document.querySelector(`.fechaVencimiento-${i}`).value){
            //         banderaSeccion2 = false;
            //     }
            // }
            // return banderaSeccion2;
            return true;

            
        case 2:
            
            cargarMuestras();
            return true;

        case 3:
            // if (document.getElementById("comprobante").value === ''){
            //     return false;
            // } else return true;
            // miFormulario = document.getElementById('formulario');
            // validarFormulario()

            // function validarFormulario() {
            //     console.log('Estoy dentro del formulario')

            //     if (!miFormulario.checkValidity()) {
            //         Swal.fire({
            //             icon: 'error',
            //             title: 'Oops...',
            //             text: 'Faltaron campos por rellenar',
            //             footer: '<a href="">¿Por qué tengo este problema?</a>'
            //         })
            //     } else {
            //         Swal.fire({
            //             position: 'top',
            //             icon: 'success',
            //             title: 'Formulario enviado correctamente',
            //             showConfirmButton: false,
            //             timer: 1500
            //         })
            //     }
            // };
            return false;
    }
}
function repetirSeccion() {
    cantidadProductos = document.getElementById('cantidadProducto').value;
    // Obtenemos la cantidad de productos seleccionada por el usuario

    const contenedorSeccion2 = document.getElementById("elementosSeccion2");
    let textoSeccion2 = '';

    for (let i = 0; i < cantidadProductos; i++) {
        textoSeccion2 += `
        <hr style="margin: 15px 0;">
        <label for="denominacionMuestra">Denominacion de la muestra:*</label>
        <input type="text" class="denominacionMuestra-${i}" name="denominacionMuestra" required><br>

        <!-- Dentro del bucle en la función repetirSeccion -->
        <label>Producto:*</label>
        <select class="producto-${i}" name="producto" required onchange="habilitarCampos(this, ${i});">
            <option value="">Seleccionar</option>
            <option value="Cerveza">Cerveza</option>
            <option value="Fernet">Fernet</option>
            <option value="Pastas">Pastas</option>
            <option value="Helados">Helados</option>
            <option value="Gaseosa">Gaseosa</option>
        </select><br>

       
        <label for="estilos" id="labelEstilo-${i}" style="margin-right: 10px;">Estilo:</label>
        <input type="text" class="estilos-${i}" name="estilos" id="inputEstilo-${i}" readOnly><br>
        <label for="marca">Marca:</label>
        <input type="text" class="marca-${i}" name="marca"><br>

        

        <label for="lote-${i}" id="labelLote-${i}" style="margin-right: 10px;">Lote:*</label>
        <input type="text" class="lote-${i}" name="lote" disabled>
        
        <label for="checkboxLote-${i}" style="margin-left: 10px; vertical-align: middle;">No tengo lote</label>
        <input type="checkbox" class="checkboxLote-${i}" name="noTieneLote" onclick="ocultarLote('lote-${i}', 'checkboxLote-${i}')"><br>

        <label for="fechaElaboracion">Fecha de elaboración:*</label>
        <input type="date" class="fechaElaboracion-${i}" name="fechaElaboracion" required><br>

        <label for="fechaVencimiento">Fecha de vencimiento:*</label>
        <input type="date" class="fechaVencimiento-${i}" name="fechaVencimiento" required><br>

        <label for="lapso">Lapso (en días): </label>
        <input type="text" class="lapso-${i}" name="lapso"><br><br>

        <label>Razón por la cual necesita realizar los análisis:*</label>
        <div>
          <input type="radio" name="razon-${i}" value="Inscripción RNPA" onchange="MostrarOtro('radioOtro-${i}', 'otroRazon-${i}')">
          <label for="razon">Inscripción RNPA</label>
        </div>
        <div>
          <input type="radio" name="razon-${i}" value="Re-inscripción RNPA" class="re_inscripcion_${i}" onchange="MostrarOtro('radioOtro-${i}', 'otroRazon-${i}')">
          <label for="razon">Re-inscripción RNPA</label>
        </div>
        <div>
          <input type="radio" name="razon-${i}" value="Control de calidad de la empresa" onchange="MostrarOtro('radioOtro-${i}', 'otroRazon-${i}')">
          <label for="razon">Control de calidad de la empresa</label>
        </div>
        <div>
          <input type="radio" class="radioOtro-${i}" name="razon-${i}" value="Otro" onchange="MostrarOtro('radioOtro-${i}', 'otroRazon-${i}')">
          <label for="razon">Otro:</label>
          <input type="text" class="otroRazon-${i}" disabled>
        </div>

        <label for="codigoAlimentario">Código alimentario argentino:</label>
        <input type="text" class="codigoAlimentario-${i}"><br><br>

        <label>Temperatura de almacenamiento:*</label>
        <div>
          <input type="radio" name="temperatura-${i}" value="Temperatura ambiente">
          <label for="temperatura">Temperatura ambiente</label>
        </div>
        <div>
          <input type="radio" name="temperatura-${i}" value="Refrigerada">
          <label for="temperatura">Refrigerada</label>
        </div>
        <div>
          <input type="radio" name="temperatura-${i}" value="Congelada">
          <label for="temperatura">Congelada</label>
        </div>
        `
    }

    contenedorSeccion2.innerHTML = textoSeccion2;
}
function habilitarCampos(selectElement, index) {
    const productoSeleccionado = selectElement.value;
    const inputEstilo = document.getElementById(`inputEstilo-${index}`);
    const inputLote = document.getElementById(`lote-${index}`);
    const checkboxLote = document.getElementById(`checkboxLote-${index}`);

    // Habilitar "Estilos" solo si la opción seleccionada es "Cerveza", de lo contrario, deshabilitar
    inputEstilo.readOnly = (productoSeleccionado !== 'Cerveza');

    // Habilitar "Lote" y "CheckboxLote" solo si la opción seleccionada es "Cerveza", de lo contrario, deshabilitar
    inputLote.disabled = checkboxLote.disabled = (productoSeleccionado !== 'Cerveza');
}


var contador = 0;

function repetirSeccion3(){
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
            <input type="checkbox" class="${data[i].id_tipo_muestra}-${contador}" name="aM" onclick="precioTotal(${data[i].precio}, '${data[i].id_tipo_muestra}-${contador}')">
            <label for="aerobiasMesofilas">${data[i].tipo_muestra} $${data[i].precio}</label><br>
            `;
            i += 1;
        };
        contador += 1;
        
        textoCompleto += `
        </div>
        <label for="analisisFisicoquimico">${data[i].tipo_muestra} $${data[i].precio}:</label>
        <input type="checkbox" class="${data[i].id_tipo_muestra}-${j}" name="analisisFisicoquimico" onclick="mostrarFisico('${data[i].id_tipo_muestra}-${j}', 'datosAnalisisFisicoquimico-${j}', 're_inscripcion_${j}'); precioTotal(${data[i].precio}, '${data[i].id_tipo_muestra}-${j}')"><br>
        
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


class Muestra{
    constructor(){
        this.analisisMicrobiologico = [];
        this.fechaIngreso = ''
    }
    

    hola(){
        console.log(this)
    }

}

function cargarMuestras(){
    cantidadProductos = document.getElementById('cantidadProducto').value;
    let muestras = []

    for (let i=0; i<cantidadProductos; i++){
        muestras[i] = new Muestra();

        // SECCION 1
        muestras[i].nombre = document.getElementById('nombre').value;
        muestras[i].apellido = document.getElementById('apellido').value;
        muestras[i].provincia = document.getElementById('provincia').value;
        muestras[i].localidad = document.getElementById('localidad').value;
        muestras[i].dni = document.getElementById('dni').value;
        muestras[i].telefono = document.getElementById('telefono').value;

        //SECCION 2
        muestras[i].denominacion = document.querySelector(`.denominacionMuestra-${i}`).value;
        muestras[i].producto = document.querySelector(`.producto-${i}`).value;
        muestras[i].marca = document.querySelector(`.marca-${i}`).value;
        muestras[i].razonSocial = document.querySelector(`.razonSocial-${i}`).value;
        muestras[i].direccion = document.querySelector(`.direccion-${i}`).value;
        muestras[i].estilo = document.querySelector(`.estilos-${i}`).value;
        muestras[i].fechaElaboracion = document.querySelector(`.fechaElaboracion-${i}`).value;
        muestras[i].fechaVencimiento = document.querySelector(`.fechaVencimiento-${i}`).value;
        muestras[i].lapso = document.querySelector(`.lapso-${i}`).value;
        muestras[i].codigoAlimentario = document.querySelector(`.codigoAlimentario-${i}`).value;

        if (document.querySelector(`.lote-${i}`).value == ''){
            muestras[i].lote = muestras[i].fechaElaboracion.replace(/-/g, '');
        } else {
            muestras[i].lote = document.querySelector(`.lote-${i}`).value;
        }

        let radios = document.getElementsByName(`razon-${i}`);

        for (const radio of radios) {
            if (radio.checked) {
                if(radio.value == 'Otro'){
                    muestras[i].razonAnalisis = document.querySelector(`.otroRazon-${i}`).value;
                } else {
                    muestras[i].razonAnalisis = radio.value;
                }
            break; // Salir del bucle al encontrar el radio seleccionado
            }
        }

        let radios2 = document.getElementsByName(`temperatura-${i}`);

        for (const radio of radios2) {
            if (radio.checked) {
                muestras[i].temperatura = radio.value;
                break; // Salir del bucle al encontrar el radio seleccionado
            }
        }

        // SECCION 3    
        let j = 0;
        let k = 0;
        muestras[i].precioTotal = 0;

        while (data[j].tipo_muestra !== 'Completo'){
            if (document.querySelector(`.${data[j].id_tipo_muestra}-${i}`).checked){
                muestras[i].analisisMicrobiologico[k] = data[j].tipo_muestra;
                muestras[i].precioTotal += parseInt(data[j].precio);
                
                k += 1;
            }
            
            j += 1;
        }

        muestras[i].analisisFisicoquimico = document.querySelector(`.${data[j].id_tipo_muestra}-${i}`).checked;
        if (muestras[i].analisisFisicoquimico){
            muestras[i].precioTotal += parseInt(data[j].precio);
        }
        muestras[i].determinacionNutricional = document.querySelector(`.${data[j+1].id_tipo_muestra}-${i}`).checked;
        if (muestras[i].determinacionNutricional){
            muestras[i].precioTotal += parseInt(data[j+1].precio);
        }
        muestras[i].azucaresTotales = document.querySelector(`.${data[j+2].id_tipo_muestra}-${i}`).checked;
        if (muestras[i].azucaresTotales){
            muestras[i].precioTotal += parseInt(data[j+2].precio);
        } 

        // SECCION 4
        muestras[i].comprobante = document.getElementById('comprobante').value
        
        // muestras[i].hola();
        console.log(convertirJSON(muestras[i]));
    }
}

function convertirJSON(muestra){
    let muestraJson = {}

    muestraJson["nombre_y_apellido"] = muestra.nombre + " " + muestra.apellido;
    muestraJson["dni"] = muestra.dni;
    muestraJson["analisis_solicitados"] = [];

    let i=0;
    for (i; i<muestra.analisisMicrobiologico.length; i++){
        muestraJson["analisis_solicitados"][i] = {
            "nombre_analisis": "Microbiológico",
            "parametros": {
            "nombre_parametros": muestra.analisisMicrobiologico[i]
            }
        }
    }

    if (muestra.analisisFisicoquimico){
        
        muestraJson["analisis_solicitados"][i] = {
            "nombre_analisis": "Fisicoquimico",
            "parametros": {
            "nombre_parametros": "---"
            }
        }
    } 
    if (muestra.determinacionNutricional){
        i += 1;
        muestraJson["analisis_solicitados"][i] = {
            "nombre_analisis": "Determinacion Nutricional",
            "parametros": {
            "nombre_parametros": "---"
            }
        }
    } 
    if (muestra.azucaresTotales){
        i += 1;
        muestraJson["analisis_solicitados"][i] = {
            "nombre_analisis": "Azucares Totales",
            "parametros": {
            "nombre_parametros": "---"
            }
        }
    }  

    muestraJson["nombre_muestra"] = muestra.denominacion;
    muestraJson["estilo"] = muestra.estilo;
    muestraJson["nro_telefono"] = muestra.telefono;
    muestraJson["producto"] = muestra.producto;
    muestraJson["lote"] = muestra.lote;
    muestraJson["precio_total"] = muestra.precioTotal;
    muestraJson["razon_analisis"] = muestra.razonAnalisis;
    muestraJson["temperatura_almacenamiento "] = muestra.temperatura;
    muestraJson["fecha_elaboracion"] = muestra.fechaElaboracion;
    muestraJson["fecha_vencimiento"] = muestra.fechaVencimiento;
    muestraJson["direccion_elaboracion"] = muestra.direccion;
    muestraJson["localidad"] = muestra.localidad;
    muestraJson["provincia"] = muestra.provincia;
    muestraJson["comprobantePago"] = muestra.comprobante;
    
    return muestraJson;
}








  
  