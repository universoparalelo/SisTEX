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


console.log(document.getElementById("hongosLevaduras").value)