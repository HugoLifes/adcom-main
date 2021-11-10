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
            pdfText = """ FRACCIONAMIENTO BOSQUES DEL REJÓN
PROCEDIMIENTO PARA EL USO DE LA CASA CLUB:
a) Para solicitar el uso de la Casa Club se deberá de acreditar estar al corriente en el pago
de las cuotas regulares de mantenimiento, así
́como de las extraordinarias que hayan sido aprobadas por la asamblea general.
b) Si se cumple con el supuesto anterior, se deberá consultar a Diana Hernández a efecto
de corroborar la disponibilidad de fechas para eventos.
c) Acto seguido deberá presentarse previa cita con alguno de los miembros de la mesa
directiva para solicitar formalmente la fecha de reserva de su evento, detallando el
tipo de evento a realizar, horario de uso, tipo de música que utilizará, y número de
personas asistentes al mismo (máximo 60 personas).
d) La Casa Club sólo podrá reservarse con anticipación a la celebración de su evento
durante 2 semanas previas a la fecha de su evento. Para confirmar su reserva se
deberán de cumplir los siguientes requisitos:
 Presentar el Contrato de uso de la Casa Club debidamente firmado. El
contrato referido deberá llevarlo previamente impreso con los datos
solicitados para ser entregado al administrador (dicho contrato deberá
solicitarlo a alguno de los miembros de la mesa directiva).
 Pagar la cantidad de 1,500.00 (MIL DOSCIENTOS PESOS 00/100 M.M.), por
concepto de reserva del salón, se toma como cuota de recuperación para la
limpieza la cantidad de 350 y el resto se regresa al entregar en optimas
condiciones el salón.
Hecho lo anterior le será entregado el recibo correspondiente a su reserva y garantía referida.
De lo contrario, la administración podrá disponer de esa fecha y pasarla a otro condómino.
e) Si previo al inicio de su evento, usted advierte algún desperfecto en la Casa Club,
deberá reportarlo de inmediato a la administración a efecto de que no le sea realizado
cargo alguno.
f) Finalizado su evento, se deberá entregar las llaves del inmueble en la caseta de
vigilancia, teniendo para ello un tiempo de tolerancia de MEDIA HORA.
g) Si en su evento se utilizó mobiliario de alquiler, se deberá reportarlo a la caseta de
vigilancia para que al día siguiente le sean proporcionadas de nueva cuenta las llaves y
se proceda a retirarlo por el proveedor que le proporcionó el servicio. El solicitante 
será responsable y deberá estar presente a la hora de realizar la entrega del mobiliario
o demás servicios que se hayan alquilado.
h) La devolución del depósito en garantía procederá dentro de las 72 horas siguientes a la
realización de su evento, previa inspección y conformidad de que el inmueble se ha
entregado tal y como se le entregó.
REGLAMENTO DE LA CASA CLUB
HORARIO DE USO.
El horario de uso establecido para la Casa Club es de 6 seis horas continuas mismo que
comprenderá́
 de las 10:00 a las 24:00 horas de domingo a jueves, y de 10:00 hasta las 2:00 horas
para viernes y sábados .
El tiempo de tolerancia para retirarse posterior al horario establecido será de 20 MINUTOS.
Desacatar esta disposición, así como el prolongar su evento fuera del horario establecido, se
procederá a hacer efectivos 500.00 pesos de multa, mismos que se tomarán del depósito en
garantía y no le será permitido al residente-usuario la renta de la Casa Club por el término de un
año.
De suscitarse cualquiera de los supuestos mencionados, el personal de seguridad está autorizado
para cortar la energía eléctrica y facultado para solicitar el apoyo de las autoridades municipales si
el caso lo amerita.
CUOTA DE RECUPERACIÓN
El uso de la Casa Club tiene un costo por evento de 1,500.00 (MIL DOSCIENTOS PESOS 00/100
M.N.) por concepto de reserva del salón.
DEPÓSITO EN GARANTÍA.
La cantidad establecida por concepto de depósito en garantía será de 1,150.00(MIL CIENTO
CINCUENTA PESOS), la cual deberá entregarse en efectivo por el residente - usuario al momento
de la firma del “contrato de uso temporal de la Casa Club”, previo a la fecha programada para su
evento.
La garantía se hará efectiva en los siguientes casos:
1. En caso de que no se haya realizado la limpieza posterior al evento (incluyendo salón
cerrado, jardín, baños, pasillos y terraza; y en caso de haber ensuciado los vidrios
también aplica).
2. En caso de que se ocasionen daños a la Casa Club o al mobiliario que se le haya sido
proporcionado.
3. Cuando termine su evento fuera del horario establecido para ello.
4. Si coloca brincolines, toldos, mesas, sillas, etc., fuera de las áreas destinadas para ello.
5. Si al término de su evento deja en la Casa Club basura, botellas, bolsas, etc.
6. Si rompe algún vidrio, puerta, chapa, mobiliario de baños.
7. En caso de que el evento se realice con escándalo, tal que provoque la queja de uno o
más condóminos y/o cuando se haga necesaria la intervención de la policía municipal
para restablecer el orden.
8. Cuando a juicio del administrador o de la mesa directiva el evento contratado por el
residente - usuario haya alterado considerablemente el orden público.
Si la garantía no alcanzare a cubrir la totalidad del daño ocasionado por el residente - usuario o
sus invitados, será requerido éste para que reembolse a la administración el dinero faltante.
En caso de negativa al requerimiento de pago, el residente- usuario será sancionado y no se le
será prestado el inmueble en lo sucesivo por un periodo de cinco años, quedando a juicio del
Consejo Directivo la sanción que deberá́
 aplicarse en lo económico. 
""";
            privacy = """ ESTACIONAMIENTO DE AUTOS ASISTENTES A SU EVENTO.
Durante el desarrollo de su evento queda estrictamente prohibido a sus invitados estacionar
vehículos en las áreas jardineadas aledañas a la Casa Club, así...como en los espacios de
estacionamiento de la casa.
El área donde deberán estacionarlos será́ frente a la casa club o terrenos vacíos únicamente.
El desacato a esta disposición será́
sancionado en los mismos
términos del artículo cuarto anterior de este reglamento. Excepcionalmente se permite el ingreso
de vehículos a los proveedores de servicios que Usted contrate para su evento sólo para dejar o
retirar mobiliario que en su caso alquile, respetando siempre el área de jardines.
RECUERDE ESTA DISPOSICIÓN EN PARTICULAR A LAS PERSONAS QUE ASISTAN A SU EVENTO Y
EVITE SER SANCIONADO. ES RESPONSABILIDAD DE USTED CUIDAR LAS AREAS VERDES DEL SALÓN
DE USOS MULTIPLES.
SERVICIOS CON QUE CUENTA LA CASA CLUB.
Para la celebración de su evento el inmueble deberá serle entregado en las siguientes condiciones:
- Con papel sanitario en los baños.
- Jabón líquido para manos.
- Papel para secado de manos.
- Mobiliario con el que cuente el inmueble al momento de la firma de su contrato.
MOBILIARIO DE ALQUILER.
Si utiliza mobiliario o cualquier otro servicio de alquiler para su evento deberá ingresarlos a la casa
Club el mismo día de su evento, no antes. Es obligación y responsabilidad del residente - usuario
retirarlo al día siguiente y previo a la celebración de otro evento, debiendo acudir a la caseta de
vigilancia para que le sean proporcionadas las llaves. Contravenir esta disposición tendrá́
 una
sanción económica de 300.00 (TRESCIENTOS PESOS 00/100 MN.) 
La mesa directiva no se hace responsable del mobiliario de alquiler que utilice el residente -
usuario, ni por objetos olvidados en la Casa Club, daños y/o accidentes que se susciten durante el
evento. Ello será́ responsabilidad exclusiva del usuario en turno.
MOBILIARIO DEL SALÓN DE USOS MÚLTIPLES.
El mobiliario entregado para su evento deberá ser cuidado por el residente-usuario, en la
inteligencia de que si lo daña estará obligado a reponerlo.
ASADORES
Queda estrictamente prohibido el uso de asadores en cualquiera de las áreas de la Casa Club.
LAS LLAVES.
Las llaves podrán recogerlas previa cita con alguno de los miembros de la mesa directiva el día del
evento, no antes. Acusará recibo haciéndose responsable de las mismas. Una vez terminado su
evento deberá́
 regresarlas en la caseta de vigilancia. Recuerde que para ello sólo cuenta con una
tolerancia de 30 MINUTOS.
LA LIMPIEZA.
Al término de su evento el residente-usuario está obligado a entregar el inmueble limpio libre de
basura mayor tal como botellas, platos, cajas, residuos de comida y piñatas, etcétera. DEBERA
COLOCAR LA BASURA QUE SE GENERE EN BOLSAS Y DEPOSITARLA EN LOS COMPARTIMENTOS QUE
SE ENCUENTRAN COLOCADOS PARA ELLO A UN COSTADO DE LA CASA CLUB.
Los objetos que utilice para adornar su evento deberán colocarse sólo en los ventanales con cinta
adhesiva. Queda prohibido utilizar silicón, cinta, clavos, tachuelas o cualquier tipo de objetos que
puedan dañar las paredes, desacatar esta disposición dará́
 lugar a hacer efectiva la garantía.
INVITADOS
Las personas que asistan a su evento serán considerados como “invitados”, la conducta que estos
desplieguen o cualquier daño al inmueble por ellos causado será responsabilidad del residenteusuario.
Queda prohibido a sus invitados deambular por el fraccionamiento y/o los cotos.
Se deberá de entregar una lista con los nombres completos de los invitados en caseta. Esto se
deberá de realizar una hora antes de que su evento de comienzo, puesto que no se le permitirá la
entrada a personas que no estén en la lista. NO CUMPLIR CON ESTE REQUISITO TENDRÁ UNA
PENALIZACIÓN DE 200.00 M.N (DOSCIENTOS PESOS 00/100 M.N.), los cuales se descontarán del
depósito en garantía.
El límite de invitados que podrán asistir a su evento será de 60 personas como máximo. En caso de
excederse el número de invitados, no les será permitirá la entrada.
Sobrepasar la capacidad del inmueble implicará, se haga efectivo el depósito en garantía y se
sancionará al residente-usuario con restricción del uso de la Casa Club durante el periodo de un
año. 
HAGA SABER A SUS INVITADOS QUE DEBEN DE RESPETAR LOS LÍMITES DE VELOCIDAD DEL
FRACCIONAMIENTO.
RUIDO Y MÚSICA
En atención a que el uso primordial de la Casa Club lo es la sana convivencia, durante su evento
queda prohibido el ruido en exceso. Por tanto QUEDAN ESTRICTAMENTE PROHIBIDOS LOS
GRUPOS MUSICALES EN VIVO CONOCIDOS COMO BANDA, CUALQUIERA QUE SEA EL NUMERO DE
ELEMENTOS. Recuerde que la música y el ruido excesivo es molesto para los condóminos que
habitan en el fraccionamiento Bosques del Rejón.
La música en vivo deberá de finalizar a las 22:00 horas los días domingo, lunes, martes, miércoles y
jueves. Para viernes y sábados se tendrá como límite las 02:00 horas.
ÁREAS VERDES O JARDINES ALEDAÑOS AL SALÓN DE USOS MÚLTIPLES
El mantenimiento de los jardines aledaños a la Casa Club corre a cargo de las cuotas del
fraccionamiento, por tanto, durante su evento deben ser especialmente cuidados por el residenteusuario y sus invitados. Queda prohibido colocar enseres comunes (mesas, sillas, bancas,
televisores, sonido, micrófonos, etc.) fuera de las áreas de la Casa Club. Estos deberán utilizarse
únicamente dentro del inmueble, quedando estrictamente prohibido colocarlos en el área
jardineada.
ASUNTOS VARIOS.
Los casos no previstos en el presente reglamento serán resueltos por la administración y/o por el
Consejo Directivo, siendo este último la única instancia para poder aplicar sanciones o multas a los
residentes-usuarios que lo infrinjan.
ES IMPORTANTE DESTACAR QUE LOS RESIDENTES USUARIOS DE LA CASA CLUB SON LOS
RESPONSABLES DE CUMPLIR Y HACER CUMPLIR CON LAS DISPOSICIONES CONTENIDAS EN EL
PRESENTE REGLAMENTO EN ATENCIÓN A LAS NORMAS DE CONVIVENCIA QUE EN
FRACCIONAMIENTO DE BOSQUES DEL REJÓN DEBE IMPERAR. RECUERDE, SU LIBERTAD TERMINA
DONDE EMPIEZA LA DE LOS DEMÁS. TODOS SOMOS IMPORTANTES EN EL FRACCIONAMIENTO Y
EN RAZÓN DE ELLO ES QUE SE PRIORIZA LA SEGURIDAD Y EL BIENESTAR DE TODOS QUIENES
AQUÍ
HABITAMOS. COMO PARTE DE UNA COMUNIDAD A LA QUE PERTENECE, ESTA SE RIGE POR
NORMAS. ¡HACER QUE ESTAS SE CUMPLAN ES DERECHO Y OBLIGACIÓN DE TODOS! 
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
Viernes, y sábados de 6:00 a 24:00 hrs
Domingos de 6:00 a 22:00 hrs
Horario de reservaciones:
Lunes a jueves de 9:00 a 22:00 hrs
Viernes y sábados de 9:00 a 24:00 hrs
Domingo NO hay reservaciones.
I. Reservaciones.
Para reservar el área de la palapa, deberá hacerse con una semana de anticipación, llenando
el formato correspondiente en vigilancia, dejando junto con él, el comprobante del depósito
previamente realizado; correspondiente a 1,000.00 mxp que se regresará intacto en caso de
no haber desperfectos en el mobiliario, limpieza y asador.
Prohibido apartar lugares cuando no se cuente con reservación.
Sólo se autoriza un evento por día con un tiempo máximo de 5 horas.
En ningún caso se permite el uso y reservación de la palapa para eventos masivos que
excedan el límite permitido como: graduaciones, quince años, fiestas escolares, bautizos,
aniversarios o cualquier evento donde se requiera pagar para entrar a este.
La cantidad máxima de invitados por evento es de 6 personas, más los residentes. (no
exceder de 12 personas en total).
Queda prohibido el uso de la alberca para cualquier evento de reservación, su uso es exclusivo de los residentes.
II. Alimentos.
Todo alimento que se lleve al área de la palapa se deberá transportar en recipientes de plástico debidamente cerrados.
Los restos de los alimentos en platos o en recipientes se deberán tirar a la basura o guardar
en éstos, no dejarlos en las mesas.
""";
            privacy = """ III. Uso del asador.
Para el uso del asador, previamente realizado el depósito de reservación, la llave para abrir
el compartimiento del gas, se solicita con el vigilante y al terminar de usarlo se deberá regresar a éste,
ese mismo día o al día siguiente a primera hora. El asador se deberá dejar totalmente limpio al igual que la tarja.
IV. Limpieza.
Al retirarse de la zona de la palapa, es necesario dejar el área igual como se entrego: mesas
y sillas en su lugar, nada de basura, mesas limpias, sin comida ni manchadas de líquidos.
El usuario se compromete a recoger el mismo día cualquier utensilio ú objeto de su propiedad
ya que el comité no se hace responsable de objetos perdidos o robados.
V. Uso después de utilizar la alberca.
En caso de haber utilizado la alberca, se solicita secarse antes de entrar al área de la palapa
para evitar accidentes y mojar los cojines de las sillas ya que se queda con el tiempo las
manchas del agua.
VI. Uso de los baños.
Para el uso de los baños del área de la palapa, se solicitarán las llaves con el guardia, los
baños se encuentran limpios y con papel, por lo que se deberán entregar limpios y cerrados
al terminar su uso, en caso de que el guardia se haya retirado antes de finalizar el evento, las
llaves se podrán regresar al día siguiente a primera hora.
VII. Mascotas.
Prohibido el acceso a cualquier tipo de mascotas en el área de palapa por higiene y seguridad sin excepciones.
VIII. Estancia de niños.
Para evitar accidentes los menores de 12 años deberán estar acompañados de un adulto. 
IX. Seguridad.
Por el bien común, están prohibidos los juegos que pudieran generar algún accidente ó
perturben la paz de los residentes, incluye el sonido excesivo de música, el uso de karaoke
queda prohibido en esta área.
Quedan prohibidas las fogatas y juegos pirotécnicos.
Ninguna persona en estado de ebriedad, bajo efecto de drogas o estupefacientes, podrá
hacer uso ó permanecer en el área de palapa.
Los usuarios de la alberca están obligados a guardar la debida compostura dentro y fuera de
ella y queda bajo su responsabilidad cualquier daño a su persona o a las instalaciones, sin
ninguna responsabilidad sobre el comité de vecinos y la asociación civil.
En la zona de palapa y en cualquier área común está prohibido bajo los lineamientos de la
ley, ingerir o portar estupefacientes o sustancias.
X. Reglas de cortesía.
No podrá efectuarse acto alguno que perturbe la tranquilidad de los demás residentes.
Se prohíbe el uso de palabras anti sonantes.
Recordar apagar las luces después de usar la zona de la palapa, recuerda que ésta es una
extensión de nuestras casas y todos debemos participar en el ahorro.
XI. Multas y sanciones.
La falta al reglamento en cualquiera de los puntos anteriores será sancionado por el comité
de vecinos dependiendo de la gravedad de la falta, pudiendo ser desde una sanción
económica, hasta la cancelación de los accesos automáticos.
XII. Cuidado de mobiliario, máquina expendedora y juegos infantiles.
Se prohíbe el mal uso del mobiliario del área de la palapa como jugar con los cojines, sillas
mesas, dañar por mal uso los juegos infantiles como la máquina expendedora o cualquier
accesorio de la palapa.
""";
          });
        } else {
          if (idAmen == 5) {
            setState(() {
              pdfText = """ Reglamento de Casa club
I. Horario
Lunes cerrado por mantenimiento.
Martes a domingo de 7:00 a 22:00 hrs.
II. Uso de la alberca.
El uso de la alberca es exclusivo de los residentes.
Queda estrictamente prohibido consumir comida en el área de la alberca.
Sólo podrán consumirse bebidas sin alcohol dentro del área de la alberca en recipientes
plásticos como thermos, etc. Queda prohibido cualquier envase de vidrio y aluminio.
La única vestimenta permitida dentro de la alberca es el traje de baño y calzado adecuado.
Los usuarios deberán ducharse antes de entrar a la alberca.
El uso de bloqueador deberá ser a prueba de agua.
Prohibido tirar basura dentro y fuera del área de alberca.
Está prohibido introducir mascotas en el área de alberca y sus alrededores.
Esta prohibido el acceso a niños menores de 12 años sin la supervisión de un adulto.
Queda estrictamente prohibido el uso de juguetes, inflables voluminosos.
Queda prohibido apartar camastros y trasladarlos fuera del área de la alberca.
La alberca no se puede reservar para eventos privados ya que es para uso exclusivo de los
residentes.
Capacidad de uso solo al 50%, lo que significa 8 personas máximo.
Queda prohibido fumar dentro de la alberca y en esta área en general.
Cada residente es responsable de mantener limpia el área de la que está haciendo uso.
""";
              privacy =
                  """Queda prohibido usar lenguaje anti sonante y ofensivo, así como juegos bruscos.
En caso de ocurrir un accidente de cualquier índole, bajo ó no del reglamento, el comité no se
hace responsable.
Los usuarios de la alberca están obligados a guardar la debida compostura dentro y fuera de
ella y queda bajo su responsabilidad cualquier daño a su persona ó a las instalaciones, sin
ninguna responsabilidad sobre el comité de vecinos y la asociación civil.
La falta al reglamento en cualquiera de los puntos anteriores será sancionada por el comité
de vecinos dependiendo de la gravedad de la falta, pudiendo ser desde una sanción
económica, hasta la cancelación de los accesos automáticos.
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
