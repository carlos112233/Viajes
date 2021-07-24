import 'dart:convert';

CpConsulta cpConsultaFromJson(String str) =>
    CpConsulta.fromJson(json.decode(str));

String cpConsultaToJson(CpConsulta data) => json.encode(data.toJson());

class CpConsulta {
  CpConsulta({
    this.claveBitacora,
    this.consecOs,
    this.folioBitacora,
    this.terminalBitacora,
    this.fechaBitacora,
    this.tractoClave,
    this.tractoNumEco,
    this.dollyNe,
    this.remNe1,
    this.remNe2,
    this.operadorClave,
    this.prefijo,
    this.statusBitacora,
    this.terminalCierre,
    this.terminalCarta,
    this.folioCarta,
    this.clienteNombre,
    this.rutaDescripcion,
    this.terminalClave,
    this.ordenserFolio,
    this.tipoUnidad,
    this.tipoUnidadDescrip,
    this.operadorNombre,
    this.cartaporte,
    this.rutaClave,
    this.tractoPlacas,
    this.fechaEntrega,
    this.fechaCarga,
    this.destinatarioNom,
    this.rutaServicio,
    this.origenNom,
    this.clienteNombreCorto,
  });

  String claveBitacora;
  String consecOs;
  String folioBitacora;
  String terminalBitacora;
  Fecha fechaBitacora;
  String tractoClave;
  String tractoNumEco;
  dynamic dollyNe;
  String remNe1;
  dynamic remNe2;
  String operadorClave;
  String prefijo;
  String statusBitacora;
  String terminalCierre;
  String terminalCarta;
  String folioCarta;
  String clienteNombre;
  String rutaDescripcion;
  String terminalClave;
  String ordenserFolio;
  String tipoUnidad;
  String tipoUnidadDescrip;
  String operadorNombre;
  String cartaporte;
  String rutaClave;
  String tractoPlacas;
  Fecha fechaEntrega;
  Fecha fechaCarga;
  String destinatarioNom;
  String rutaServicio;
  String origenNom;
  String clienteNombreCorto;

  factory CpConsulta.fromJson(Map<String, dynamic> json) => CpConsulta(
        claveBitacora: json["CLAVE_BITACORA"],
        consecOs: json["CONSEC_OS"],
        folioBitacora: json["FOLIO_BITACORA"],
        terminalBitacora: json["TERMINAL_BITACORA"],
        fechaBitacora: Fecha.fromJson(json["FECHA_BITACORA"]),
        tractoClave: json["TRACTO_CLAVE"],
        tractoNumEco: json["TRACTO_NUM_ECO"],
        dollyNe: json["DOLLY_NE"],
        remNe1: json["REM_NE1"],
        remNe2: json["REM_NE2"],
        operadorClave: json["OPERADOR_CLAVE"],
        prefijo: json["PREFIJO"],
        statusBitacora: json["STATUS_BITACORA"],
        terminalCierre: json["terminal_cierre"],
        terminalCarta: json["terminal_carta"],
        folioCarta: json["folio_carta"],
        clienteNombre: json["cliente_nombre"],
        rutaDescripcion: json["ruta_descripcion"],
        terminalClave: json["terminal_clave"],
        ordenserFolio: json["ordenser_folio"],
        tipoUnidad: json["tipo_unidad"],
        tipoUnidadDescrip: json["tipo_unidad_descrip"],
        operadorNombre: json["operador_nombre"],
        cartaporte: json["cartaporte"],
        rutaClave: json["ruta_clave"],
        tractoPlacas: json["tracto_placas"],
        fechaEntrega: Fecha.fromJson(json["fecha_entrega"]),
        fechaCarga: Fecha.fromJson(json["fecha_carga"]),
        destinatarioNom: json["destinatario_nom"],
        rutaServicio: json["ruta_servicio"],
        origenNom: json["origen_nom"],
        clienteNombreCorto: json["cliente_nombre_corto"],
      );

  Map<String, dynamic> toJson() => {
        "CLAVE_BITACORA": claveBitacora,
        "CONSEC_OS": consecOs,
        "FOLIO_BITACORA": folioBitacora,
        "TERMINAL_BITACORA": terminalBitacora,
        "FECHA_BITACORA": fechaBitacora.toJson(),
        "TRACTO_CLAVE": tractoClave,
        "TRACTO_NUM_ECO": tractoNumEco,
        "DOLLY_NE": dollyNe,
        "REM_NE1": remNe1,
        "REM_NE2": remNe2,
        "OPERADOR_CLAVE": operadorClave,
        "PREFIJO": prefijo,
        "STATUS_BITACORA": statusBitacora,
        "terminal_cierre": terminalCierre,
        "terminal_carta": terminalCarta,
        "folio_carta": folioCarta,
        "cliente_nombre": clienteNombre,
        "ruta_descripcion": rutaDescripcion,
        "terminal_clave": terminalClave,
        "ordenser_folio": ordenserFolio,
        "tipo_unidad": tipoUnidad,
        "tipo_unidad_descrip": tipoUnidadDescrip,
        "operador_nombre": operadorNombre,
        "cartaporte": cartaporte,
        "ruta_clave": rutaClave,
        "tracto_placas": tractoPlacas,
        "fecha_entrega": fechaEntrega.toJson(),
        "fecha_carga": fechaCarga.toJson(),
        "destinatario_nom": destinatarioNom,
        "ruta_servicio": rutaServicio,
        "origen_nom": origenNom,
        "cliente_nombre_corto": clienteNombreCorto,
      };
}

class Fecha {
  Fecha({
    this.date,
    this.timezoneType,
    this.timezone,
  });

  DateTime date;
  int timezoneType;
  String timezone;

  factory Fecha.fromJson(Map<String, dynamic> json) => Fecha(
        date: DateTime.parse(json["date"]),
        timezoneType: json["timezone_type"],
        timezone: json["timezone"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "timezone_type": timezoneType,
        "timezone": timezone,
      };
}
