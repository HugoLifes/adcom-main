import 'package:adcom/src/methods/slide.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboard/flutter_onboard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? prefs;

class Reglamento extends StatefulWidget {
  final int? idAmen;
  final int? idCom;
  Reglamento({this.idAmen, this.idCom});
  @override
  _ReglamentoState createState() => _ReglamentoState();
}

class _ReglamentoState extends State<Reglamento> {
  ScrollController controller = ScrollController();
  bool leido = false;
  Text titulo = Text(
    'Reglamento de amenidades',
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
  bool aceptarTodo = false;
  bool aceptarTerminos = false;
  bool aceptarPrivacidad = false;
  String? pdfText;

  String? privacy;

  getDt() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      controller.position.isScrollingNotifier.addListener(() {
        if (controller.position.pixels == controller.position.maxScrollExtent) {
          setState(() {
            leido = true;
          });
        }
      });
    });
    getDt();
    textoAmostrar(widget.idCom!, widget.idAmen!);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return SafeArea(
        child: new Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              controller: controller,
              child: Padding(
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  children: [
                    imagenAMostrar(),
                    SizedBox(
                      height: 15,
                    ),
                    formText('Aceptar todo'),
                    detailsText(pdfText!),
                    detailsText(privacy!),
                    aceptTerms()
                  ],
                ),
              ),
            )));
  }

  aceptTerms() {
    return leido == true
        ? new TextButton(
            onPressed: () async {
              if (aceptarTodo == true) {
                prefs!.setBool('UnaVez2', true);
                Navigator.of(context).pop('User Agreed');
              } else {
                Fluttertoast.showToast(
                    msg: "No acepto los terminos",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    fontSize: 17.0);
              }
            },
            child: Text(
              'De acuerdo',
              style: TextStyle(color: Colors.deepPurple, fontSize: 18),
            ))
        : Container();
  }

  Row formText(String text) {
    return Row(
      children: [
        Checkbox(
            value: aceptarTodo,
            onChanged: (v) {
              setState(() {
                aceptarTodo = v!;
              });
            }),
        Text(
          text,
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  detailsText(String text) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
    );
  }

  textoAmostrar(int idCom, idAmen) {
    switch (idCom) {
      case 1:
        if (idAmen == 5) {
          setState(() {
            pdfText = """ FRACCIONAMIENTO BOSQUES DEL REJ??N

PROCEDIMIENTO PARA EL USO DE LA CASA CLUB:

a) Para solicitar el uso de la Casa Club se deber?? de acreditar estar al corriente en el pago
de las cuotas regulares de mantenimiento, as??
??como de las extraordinarias que hayan sido aprobadas por la asamblea general.

b) Si se cumple con el supuesto anterior, se deber?? consultar a Diana Hern??ndez a efecto
de corroborar la disponibilidad de fechas para eventos.

c) Acto seguido deber?? presentarse previa cita con alguno de los miembros de la mesa
directiva para solicitar formalmente la fecha de reserva de su evento, detallando el
tipo de evento a realizar, horario de uso, tipo de m??sica que utilizar??, y n??mero de
personas asistentes al mismo (m??ximo 60 personas).

d) La Casa Club s??lo podr?? reservarse con anticipaci??n a la celebraci??n de su evento
durante 2 semanas previas a la fecha de su evento. Para confirmar su reserva se
deber??n de cumplir los siguientes requisitos:
??? Presentar el Contrato de uso de la Casa Club debidamente firmado. El
contrato referido deber?? llevarlo previamente impreso con los datos
solicitados para ser entregado al administrador (dicho contrato deber??
solicitarlo a alguno de los miembros de la mesa directiva).

??? Pagar la cantidad de 1,500.00 (MIL DOSCIENTOS PESOS 00/100 M.M.), por
concepto de reserva del sal??n, se toma como cuota de recuperaci??n para la
limpieza la cantidad de 350 y el resto se regresa al entregar en optimas
condiciones el sal??n.
Hecho lo anterior le ser?? entregado el recibo correspondiente a su reserva y garant??a referida.
De lo contrario, la administraci??n podr?? disponer de esa fecha y pasarla a otro cond??mino.

e) Si previo al inicio de su evento, usted advierte alg??n desperfecto en la Casa Club,
deber?? reportarlo de inmediato a la administraci??n a efecto de que no le sea realizado
cargo alguno.

f) Finalizado su evento, se deber?? entregar las llaves del inmueble en la caseta de
vigilancia, teniendo para ello un tiempo de tolerancia de MEDIA HORA.

g) Si en su evento se utiliz?? mobiliario de alquiler, se deber?? reportarlo a la caseta de
vigilancia para que al d??a siguiente le sean proporcionadas de nueva cuenta las llaves y
se proceda a retirarlo por el proveedor que le proporcion?? el servicio. El solicitante 
ser?? responsable y deber?? estar presente a la hora de realizar la entrega del mobiliario
o dem??s servicios que se hayan alquilado.

h) La devoluci??n del dep??sito en garant??a proceder?? dentro de las 72 horas siguientes a la
realizaci??n de su evento, previa inspecci??n y conformidad de que el inmueble se ha
entregado tal y como se le entreg??.

REGLAMENTO DE LA CASA CLUB
HORARIO DE USO.
El horario de uso establecido para la Casa Club es de 6 seis horas continuas mismo que
comprender????
 de las 10:00 a las 24:00 horas de domingo a jueves, y de 10:00 hasta las 2:00 horas
para viernes y s??bados .

El tiempo de tolerancia para retirarse posterior al horario establecido ser?? de 20 MINUTOS.
Desacatar esta disposici??n, as?? como el prolongar su evento fuera del horario establecido, se
proceder?? a hacer efectivos 500.00 pesos de multa, mismos que se tomar??n del dep??sito en
garant??a y no le ser?? permitido al residente-usuario la renta de la Casa Club por el t??rmino de un
a??o.

De suscitarse cualquiera de los supuestos mencionados, el personal de seguridad est?? autorizado
para cortar la energ??a el??ctrica y facultado para solicitar el apoyo de las autoridades municipales si
el caso lo amerita.

CUOTA DE RECUPERACI??N
El uso de la Casa Club tiene un costo por evento de 1,500.00 (MIL DOSCIENTOS PESOS 00/100
M.N.) por concepto de reserva del sal??n.
DEP??SITO EN GARANT??A.

La cantidad establecida por concepto de dep??sito en garant??a ser?? de 1,150.00(MIL CIENTO
CINCUENTA PESOS), la cual deber?? entregarse en efectivo por el residente - usuario al momento
de la firma del ???contrato de uso temporal de la Casa Club???, previo a la fecha programada para su
evento.
La garant??a se har?? efectiva en los siguientes casos:

1. En caso de que no se haya realizado la limpieza posterior al evento (incluyendo sal??n
cerrado, jard??n, ba??os, pasillos y terraza; y en caso de haber ensuciado los vidrios
tambi??n aplica).

2. En caso de que se ocasionen da??os a la Casa Club o al mobiliario que se le haya sido
proporcionado.

3. Cuando termine su evento fuera del horario establecido para ello.

4. Si coloca brincolines, toldos, mesas, sillas, etc., fuera de las ??reas destinadas para ello.

5. Si al t??rmino de su evento deja en la Casa Club basura, botellas, bolsas, etc.


6. Si rompe alg??n vidrio, puerta, chapa, mobiliario de ba??os.

7. En caso de que el evento se realice con esc??ndalo, tal que provoque la queja de uno o
m??s cond??minos y/o cuando se haga necesaria la intervenci??n de la polic??a municipal
para restablecer el orden.

8. Cuando a juicio del administrador o de la mesa directiva el evento contratado por el
residente - usuario haya alterado considerablemente el orden p??blico.
Si la garant??a no alcanzare a cubrir la totalidad del da??o ocasionado por el residente - usuario o
sus invitados, ser?? requerido ??ste para que reembolse a la administraci??n el dinero faltante.
En caso de negativa al requerimiento de pago, el residente- usuario ser?? sancionado y no se le
ser?? prestado el inmueble en lo sucesivo por un periodo de cinco a??os, quedando a juicio del
Consejo Directivo la sanci??n que deber????
 aplicarse en lo econ??mico. 
""";
            privacy = """ ESTACIONAMIENTO DE AUTOS ASISTENTES A SU EVENTO.
Durante el desarrollo de su evento queda estrictamente prohibido a sus invitados estacionar
veh??culos en las ??reas jardineadas aleda??as a la Casa Club, as??...como en los espacios de
estacionamiento de la casa.

El ??rea donde deber??n estacionarlos ser???? frente a la casa club o terrenos vac??os ??nicamente.
El desacato a esta disposici??n ser????
sancionado en los mismos

t??rminos del art??culo cuarto anterior de este reglamento. Excepcionalmente se permite el ingreso
de veh??culos a los proveedores de servicios que Usted contrate para su evento s??lo para dejar o
retirar mobiliario que en su caso alquile, respetando siempre el ??rea de jardines.
RECUERDE ESTA DISPOSICI??N EN PARTICULAR A LAS PERSONAS QUE ASISTAN A SU EVENTO Y
EVITE SER SANCIONADO. ES RESPONSABILIDAD DE USTED CUIDAR LAS AREAS VERDES DEL SAL??N
DE USOS MULTIPLES.

SERVICIOS CON QUE CUENTA LA CASA CLUB.
Para la celebraci??n de su evento el inmueble deber?? serle entregado en las siguientes condiciones:
- Con papel sanitario en los ba??os.
- Jab??n l??quido para manos.
- Papel para secado de manos.
- Mobiliario con el que cuente el inmueble al momento de la firma de su contrato.

MOBILIARIO DE ALQUILER.
Si utiliza mobiliario o cualquier otro servicio de alquiler para su evento deber?? ingresarlos a la casa
Club el mismo d??a de su evento, no antes. Es obligaci??n y responsabilidad del residente - usuario
retirarlo al d??a siguiente y previo a la celebraci??n de otro evento, debiendo acudir a la caseta de
vigilancia para que le sean proporcionadas las llaves. Contravenir esta disposici??n tendr????
 una

sanci??n econ??mica de 300.00 (TRESCIENTOS PESOS 00/100 MN.) 
La mesa directiva no se hace responsable del mobiliario de alquiler que utilice el residente -
usuario, ni por objetos olvidados en la Casa Club, da??os y/o accidentes que se susciten durante el
evento. Ello ser???? responsabilidad exclusiva del usuario en turno.

MOBILIARIO DEL SAL??N DE USOS M??LTIPLES.
El mobiliario entregado para su evento deber?? ser cuidado por el residente-usuario, en la
inteligencia de que si lo da??a estar?? obligado a reponerlo.

ASADORES
Queda estrictamente prohibido el uso de asadores en cualquiera de las ??reas de la Casa Club.

LAS LLAVES.
Las llaves podr??n recogerlas previa cita con alguno de los miembros de la mesa directiva el d??a del
evento, no antes. Acusar?? recibo haci??ndose responsable de las mismas. Una vez terminado su
evento deber????
 regresarlas en la caseta de vigilancia. Recuerde que para ello s??lo cuenta con una
tolerancia de 30 MINUTOS.


LA LIMPIEZA.
Al t??rmino de su evento el residente-usuario est?? obligado a entregar el inmueble limpio libre de
basura mayor tal como botellas, platos, cajas, residuos de comida y pi??atas, etc??tera. DEBERA
COLOCAR LA BASURA QUE SE GENERE EN BOLSAS Y DEPOSITARLA EN LOS COMPARTIMENTOS QUE
SE ENCUENTRAN COLOCADOS PARA ELLO A UN COSTADO DE LA CASA CLUB.

Los objetos que utilice para adornar su evento deber??n colocarse s??lo en los ventanales con cinta
adhesiva. Queda prohibido utilizar silic??n, cinta, clavos, tachuelas o cualquier tipo de objetos que
puedan da??ar las paredes, desacatar esta disposici??n dar????
 lugar a hacer efectiva la garant??a.

INVITADOS
Las personas que asistan a su evento ser??n considerados como ???invitados???, la conducta que estos
desplieguen o cualquier da??o al inmueble por ellos causado ser?? responsabilidad del residenteusuario.
Queda prohibido a sus invitados deambular por el fraccionamiento y/o los cotos.

Se deber?? de entregar una lista con los nombres completos de los invitados en caseta. Esto se
deber?? de realizar una hora antes de que su evento de comienzo, puesto que no se le permitir?? la
entrada a personas que no est??n en la lista. NO CUMPLIR CON ESTE REQUISITO TENDR?? UNA
PENALIZACI??N DE 200.00 M.N (DOSCIENTOS PESOS 00/100 M.N.), los cuales se descontar??n del
dep??sito en garant??a.

El l??mite de invitados que podr??n asistir a su evento ser?? de 60 personas como m??ximo. En caso de
excederse el n??mero de invitados, no les ser?? permitir?? la entrada.
Sobrepasar la capacidad del inmueble implicar??, se haga efectivo el dep??sito en garant??a y se
sancionar?? al residente-usuario con restricci??n del uso de la Casa Club durante el periodo de un
a??o. 
HAGA SABER A SUS INVITADOS QUE DEBEN DE RESPETAR LOS L??MITES DE VELOCIDAD DEL
FRACCIONAMIENTO.

RUIDO Y M??SICA
En atenci??n a que el uso primordial de la Casa Club lo es la sana convivencia, durante su evento
queda prohibido el ruido en exceso. Por tanto QUEDAN ESTRICTAMENTE PROHIBIDOS LOS
GRUPOS MUSICALES EN VIVO CONOCIDOS COMO BANDA, CUALQUIERA QUE SEA EL NUMERO DE
ELEMENTOS. Recuerde que la m??sica y el ruido excesivo es molesto para los cond??minos que
habitan en el fraccionamiento Bosques del Rej??n.

La m??sica en vivo deber?? de finalizar a las 22:00 horas los d??as domingo, lunes, martes, mi??rcoles y
jueves. Para viernes y s??bados se tendr?? como l??mite las 02:00 horas.
??REAS VERDES O JARDINES ALEDA??OS AL SAL??N DE USOS M??LTIPLES
El mantenimiento de los jardines aleda??os a la Casa Club corre a cargo de las cuotas del
fraccionamiento, por tanto, durante su evento deben ser especialmente cuidados por el residenteusuario y sus invitados. Queda prohibido colocar enseres comunes (mesas, sillas, bancas,
televisores, sonido, micr??fonos, etc.) fuera de las ??reas de la Casa Club. Estos deber??n utilizarse
??nicamente dentro del inmueble, quedando estrictamente prohibido colocarlos en el ??rea
jardineada.

ASUNTOS VARIOS.
Los casos no previstos en el presente reglamento ser??n resueltos por la administraci??n y/o por el
Consejo Directivo, siendo este ??ltimo la ??nica instancia para poder aplicar sanciones o multas a los
residentes-usuarios que lo infrinjan.


ES IMPORTANTE DESTACAR QUE LOS RESIDENTES USUARIOS DE LA CASA CLUB SON LOS
RESPONSABLES DE CUMPLIR Y HACER CUMPLIR CON LAS DISPOSICIONES CONTENIDAS EN EL
PRESENTE REGLAMENTO EN ATENCI??N A LAS NORMAS DE CONVIVENCIA QUE EN
FRACCIONAMIENTO DE BOSQUES DEL REJ??N DEBE IMPERAR. RECUERDE, SU LIBERTAD TERMINA
DONDE EMPIEZA LA DE LOS DEM??S. TODOS SOMOS IMPORTANTES EN EL FRACCIONAMIENTO Y
EN RAZ??N DE ELLO ES QUE SE PRIORIZA LA SEGURIDAD Y EL BIENESTAR DE TODOS QUIENES
AQU??
HABITAMOS. COMO PARTE DE UNA COMUNIDAD A LA QUE PERTENECE, ESTA SE RIGE POR
NORMAS. ??HACER QUE ESTAS SE CUMPLAN ES DERECHO Y OBLIGACI??N DE TODOS! 
""";
          });
        }
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        if (idAmen == 2) {
          setState(() {
            pdfText = """ Reglamento de Palapa
I. Horarios
Horarios de uso:
Lunes a jueves de 6:00 a 22:00 hrs
Viernes, y s??bados de 6:00 a 24:00 hrs
Domingos de 6:00 a 22:00 hrs
Horario de reservaciones:
Lunes a jueves de 9:00 a 22:00 hrs
Viernes y s??bados de 9:00 a 24:00 hrs
Domingo NO hay reservaciones.
I. Reservaciones.
Para reservar el ??rea de la palapa, deber?? hacerse con una semana de anticipaci??n, llenando
el formato correspondiente en vigilancia, dejando junto con ??l, el comprobante del dep??sito
previamente realizado; correspondiente a 1,000.00 mxp que se regresar?? intacto en caso de
no haber desperfectos en el mobiliario, limpieza y asador.
Prohibido apartar lugares cuando no se cuente con reservaci??n.
S??lo se autoriza un evento por d??a con un tiempo m??ximo de 5 horas.
En ning??n caso se permite el uso y reservaci??n de la palapa para eventos masivos que
excedan el l??mite permitido como: graduaciones, quince a??os, fiestas escolares, bautizos,
aniversarios o cualquier evento donde se requiera pagar para entrar a este.
La cantidad m??xima de invitados por evento es de 6 personas, m??s los residentes. (no
exceder de 12 personas en total).
Queda prohibido el uso de la alberca para cualquier evento de reservaci??n, su uso es exclusivo de los residentes.
II. Alimentos.
Todo alimento que se lleve al ??rea de la palapa se deber?? transportar en recipientes de pl??stico debidamente cerrados.
Los restos de los alimentos en platos o en recipientes se deber??n tirar a la basura o guardar
en ??stos, no dejarlos en las mesas.
""";
            privacy = """ III. Uso del asador.
Para el uso del asador, previamente realizado el dep??sito de reservaci??n, la llave para abrir
el compartimiento del gas, se solicita con el vigilante y al terminar de usarlo se deber?? regresar a ??ste,
ese mismo d??a o al d??a siguiente a primera hora. El asador se deber?? dejar totalmente limpio al igual que la tarja.
IV. Limpieza.
Al retirarse de la zona de la palapa, es necesario dejar el ??rea igual como se entrego: mesas
y sillas en su lugar, nada de basura, mesas limpias, sin comida ni manchadas de l??quidos.
El usuario se compromete a recoger el mismo d??a cualquier utensilio ?? objeto de su propiedad
ya que el comit?? no se hace responsable de objetos perdidos o robados.
V. Uso despu??s de utilizar la alberca.
En caso de haber utilizado la alberca, se solicita secarse antes de entrar al ??rea de la palapa
para evitar accidentes y mojar los cojines de las sillas ya que se queda con el tiempo las
manchas del agua.
VI. Uso de los ba??os.
Para el uso de los ba??os del ??rea de la palapa, se solicitar??n las llaves con el guardia, los
ba??os se encuentran limpios y con papel, por lo que se deber??n entregar limpios y cerrados
al terminar su uso, en caso de que el guardia se haya retirado antes de finalizar el evento, las
llaves se podr??n regresar al d??a siguiente a primera hora.
VII. Mascotas.
Prohibido el acceso a cualquier tipo de mascotas en el ??rea de palapa por higiene y seguridad sin excepciones.
VIII. Estancia de ni??os.
Para evitar accidentes los menores de 12 a??os deber??n estar acompa??ados de un adulto. 
IX. Seguridad.
Por el bien com??n, est??n prohibidos los juegos que pudieran generar alg??n accidente ??
perturben la paz de los residentes, incluye el sonido excesivo de m??sica, el uso de karaoke
queda prohibido en esta ??rea.
Quedan prohibidas las fogatas y juegos pirot??cnicos.
Ninguna persona en estado de ebriedad, bajo efecto de drogas o estupefacientes, podr??
hacer uso ?? permanecer en el ??rea de palapa.
Los usuarios de la alberca est??n obligados a guardar la debida compostura dentro y fuera de
ella y queda bajo su responsabilidad cualquier da??o a su persona o a las instalaciones, sin
ninguna responsabilidad sobre el comit?? de vecinos y la asociaci??n civil.
En la zona de palapa y en cualquier ??rea com??n est?? prohibido bajo los lineamientos de la
ley, ingerir o portar estupefacientes o sustancias.
X. Reglas de cortes??a.
No podr?? efectuarse acto alguno que perturbe la tranquilidad de los dem??s residentes.
Se proh??be el uso de palabras anti sonantes.
Recordar apagar las luces despu??s de usar la zona de la palapa, recuerda que ??sta es una
extensi??n de nuestras casas y todos debemos participar en el ahorro.
XI. Multas y sanciones.
La falta al reglamento en cualquiera de los puntos anteriores ser?? sancionado por el comit??
de vecinos dependiendo de la gravedad de la falta, pudiendo ser desde una sanci??n
econ??mica, hasta la cancelaci??n de los accesos autom??ticos.
XII. Cuidado de mobiliario, m??quina expendedora y juegos infantiles.
Se proh??be el mal uso del mobiliario del ??rea de la palapa como jugar con los cojines, sillas
mesas, da??ar por mal uso los juegos infantiles como la m??quina expendedora o cualquier
accesorio de la palapa.
""";
          });
        } else {
          if (idAmen == 1) {
            setState(() {
              pdfText = """ Reglamento de la alberca.
I. Horario
Lunes cerrado por mantenimiento.
Martes a domingo de 7:00 a 22:00 hrs.

II. Uso de la alberca.
El uso de la alberca es exclusivo de los residentes.
Queda estrictamente prohibido consumir comida en el ??rea de la alberca.
S??lo podr??n consumirse bebidas sin alcohol dentro del ??rea de la alberca en recipientes
pl??sticos como thermos, etc. Queda prohibido cualquier envase de vidrio y aluminio.
La ??nica vestimenta permitida dentro de la alberca es el traje de ba??o y calzado adecuado.
Los usuarios deber??n ducharse antes de entrar a la alberca.
El uso de bloqueador deber?? ser a prueba de agua.
Prohibido tirar basura dentro y fuera del ??rea de alberca.
Est?? prohibido introducir mascotas en el ??rea de alberca y sus alrededores.
Esta prohibido el acceso a ni??os menores de 12 a??os sin la supervisi??n de un adulto.
Queda estrictamente prohibido el uso de juguetes, inflables voluminosos.
Queda prohibido apartar camastros y trasladarlos fuera del ??rea de la alberca.
La alberca no se puede reservar para eventos privados ya que es para uso exclusivo de los
residentes.
Capacidad de uso solo al 50%, lo que significa 8 personas m??ximo.
Queda prohibido fumar dentro de la alberca y en esta ??rea en general.
Cada residente es responsable de mantener limpia el ??rea de la que est?? haciendo uso.
""";
              privacy =
                  """ Queda prohibido usar lenguaje anti sonante y ofensivo, as?? como juegos bruscos.
En caso de ocurrir un accidente de cualquier ??ndole, bajo ?? no del reglamento, el comit?? no se
hace responsable.
Los usuarios de la alberca est??n obligados a guardar la debida compostura dentro y fuera de
ella y queda bajo su responsabilidad cualquier da??o a su persona ?? a las instalaciones, sin
ninguna responsabilidad sobre el comit?? de vecinos y la asociaci??n civil.
La falta al reglamento en cualquiera de los puntos anteriores ser?? sancionada por el comit??
de vecinos dependiendo de la gravedad de la falta, pudiendo ser desde una sanci??n
econ??mica, hasta la cancelaci??n de los accesos autom??ticos.
          """;
            });
          }
        }
        break;
      case 5:
        break;
      case 6:
        break;
      case 10:
        break;
      case 99:
        return Container();
      default:
    }
  }

  imagenAMostrar() {
    switch (widget.idCom) {
      case 1:
        return Container(child: Image.asset("assets/images/bosques.png"));

      case 2:
        break;
      case 3:
        break;
      case 4:
        return Container(child: Image.asset("assets/images/moticello.png"));

      case 5:
        break;
      case 6:
        break;
      case 10:
        break;
      case 99:
        return Container();

      default:
    }
  }
}
