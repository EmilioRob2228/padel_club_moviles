const { onCall, onRequest, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const { getDownloadURL } = require("firebase-admin/storage");

admin.initializeApp();
const db = admin.firestore();
const stripeKey = defineSecret("STRIPE_SECRET_KEY");

exports.crearPagoMembresia = onCall({ secrets: [stripeKey] }, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Inicia sesión para pagar");
  }
  const planId = request.data.planId;
  const plan = await db.collection("planes").doc(planId).get();
  if (!plan.exists) {
    throw new HttpsError("not-found", "El plan no existe");
  }
  const stripe = require("stripe")(stripeKey.value());
  const pago = await stripe.paymentIntents.create({
    amount: Math.round(plan.data().precio * 100),
    currency: "mxn",
    payment_method_types: ["card"],
    metadata: { uid: request.auth.uid, planId: planId },
  });
  return {
    clientSecret: pago.client_secret,
    paymentIntentId: pago.id,
    monto: plan.data().precio,
  };
});

async function urlFoto(ruta) {
  try {
    return await getDownloadURL(admin.storage().bucket().file(ruta));
  } catch (e) {
    return "";
  }
}

exports.cargarDatosPrueba = onRequest(async (req, res) => {
  const planes = [
    { id: "basica", nombre: "Básica", precio: 299, beneficios: ["2 reservas por semana", "Reserva con 3 días de anticipación"] },
    { id: "premium", nombre: "Premium", precio: 549, beneficios: ["5 reservas por semana", "Reserva con 7 días de anticipación", "Renta de palas incluida"] },
    { id: "vip", nombre: "VIP", precio: 899, beneficios: ["Reservas ilimitadas", "Reserva con 14 días de anticipación", "Renta de palas y pelotas", "Clase mensual con entrenador"] },
  ];
  for (const p of planes) {
    const { id, ...datos } = p;
    await db.collection("planes").doc(id).set(datos);
  }

  const fotoTorres = await urlFoto("sedes/torreslanda.jpg");
  const fotoCampestre = await urlFoto("sedes/campestre.jpg");

  const sedes = [
    {
      id: "torreslanda",
      nombre: "Sede Torres Landa",
      direccion: "Blvd. Juan José Torres Landa 1200, Celaya, Gto.",
      lat: 20.5285,
      lng: -100.7955,
      fotoUrl: fotoTorres,
      horarioApertura: 7,
      horarioCierre: 23,
      topic: "sede_torreslanda",
    },
    {
      id: "campestre",
      nombre: "Sede Campestre",
      direccion: "Blvd. Adolfo López Mateos 2300, Col. Campestre, Celaya, Gto.",
      lat: 20.5352,
      lng: -100.8296,
      fotoUrl: fotoCampestre,
      horarioApertura: 7,
      horarioCierre: 22,
      topic: "sede_campestre",
    },
  ];
  for (const s of sedes) {
    const { id, ...datos } = s;
    await db.collection("sedes").doc(id).set(datos);
  }

  const canchas = [
    { id: "torreslanda_1", sedeId: "torreslanda", nombre: "Cancha 1", tipo: "Techada", tarifaHora: 350, ruta: "canchas/torreslanda_1.jpg", respaldo: fotoTorres },
    { id: "torreslanda_2", sedeId: "torreslanda", nombre: "Cancha 2", tipo: "Descubierta", tarifaHora: 300, ruta: "canchas/torreslanda_2.jpg", respaldo: fotoTorres },
    { id: "campestre_1", sedeId: "campestre", nombre: "Cancha 1", tipo: "Techada", tarifaHora: 380, ruta: "canchas/campestre_1.jpg", respaldo: fotoCampestre },
    { id: "campestre_2", sedeId: "campestre", nombre: "Cancha 2", tipo: "Descubierta", tarifaHora: 320, ruta: "canchas/campestre_2.jpg", respaldo: fotoCampestre },
  ];
  for (const c of canchas) {
    const foto = (await urlFoto(c.ruta)) || c.respaldo;
    await db.collection("canchas").doc(c.id).set({
      sedeId: c.sedeId,
      nombre: c.nombre,
      tipo: c.tipo,
      tarifaHora: c.tarifaHora,
      fotoUrl: foto,
    });
  }

  res.send("Datos de prueba cargados: 3 planes, 2 sedes y 4 canchas.");
});
